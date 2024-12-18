<?php

namespace App\Http\Controllers;

// use Storage;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
// use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors(),
            ], 422);
        }
    
        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = Auth::user();
    
            return response()->json([
                'message' => 'Login successful',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role, 
                ],
            ], 200);
        } else {
            return response()->json([
                'message' => 'Unauthorized, wrong email or password',
            ], 401);
        }
    }
    

    public function register(Request $request)
    {
        // Validasi input dari request
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'role' => 'required|in:admin,siswa,guru,orang_tua,kepala_sekolah',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240',
            'nomor_absen' => 'nullable|integer|min:1', // Validasi untuk nomor_absen
        ]);
    
        // Mengatur upload gambar jika ada
        $imagePath = null; // Inisialisasi variabel path foto
        if ($request->hasFile('photo')) {
            // Membuat direktori jika belum ada
            if (!Storage::exists('public/images/users')) {
                Storage::makeDirectory('public/images/users');
            }
    
            // Simpan gambar ke folder public/images/users
            $imagePath = $request->file('photo')->store('images/users', 'public');
        }
    
        // Hash password sebelum disimpan
        $hashedPassword = bcrypt($request->password);
    
        // Menyimpan data pengguna ke database
        try {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => $hashedPassword,
                'role' => $request->role,
                'photo' => $imagePath, // Menyimpan path gambar jika ada
                'nomor_absen' => $request->nomor_absen, // Menambahkan nomor_absen
            ]);
    
            // Jika user berhasil dibuat
            return response()->json([
                'message' => 'Akun berhasil terdaftar!',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'nomor_absen' => $user->nomor_absen, // Menyertakan nomor_absen dalam respons
                    'image_url' => $imagePath ? asset('storage/' . $imagePath) : null, // URL untuk akses gambar
                ],
            ], 201);
    
        } catch (\Exception $e) {
            // Menangani error saat proses insert
            return response()->json([
                'message' => 'Terjadi kesalahan: ' . $e->getMessage(),
            ], 500);
        }
    }
    
    

    public function logout(Request $request)
    {
        Auth::logout();

        return response()->json([
            'message' => 'Logout successful',
        ], 200);
    }


    public function index()
    {
        $query = DB::connection('mysql')->table('users')->get();
        if ($query->isEmpty()) {
            return response()->json([
                'message' => 'Tidak ada data pengguna.',
            ], 200);
        }
    
        return response()->json($query, 200);
    }
    

        public function get_user($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'User not found.',
            ], 404);
        }

        return response()->json([
            'message' => 'User di temukan !!',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
            ],
        ], 200);
    }

    public function update(Request $request, $id)
{
    // Validasi input
    $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255',
        'password' => 'nullable|string|min:8',
        'role' => 'required|string|in:admin,siswa,guru,orang_tua,kepala_sekolah',
        'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240', 
        'nomor_absen' => 'nullable|integer|min:1', // Validasi nomor_absen
    ]);

    // Cari user berdasarkan ID
    $user = User::find($id);
    if (!$user) {
        return response()->json(['message' => 'User tidak ditemukan'], 404);
    }

    // Cek duplikat username atau email
    $existingUser = User::where(function ($query) use ($request, $id) {
        $query->where('email', $request->email)
              ->orWhere('name', $request->name);
    })->where('id', '!=', $id)->first();

    if ($existingUser) {
        return response()->json(['message' => 'Username atau email sudah digunakan oleh user lain'], 400);
    }

    // Upload foto baru jika ada
    $photoPath = $user->photo; // Gunakan foto lama jika tidak ada yang di-upload
    if ($request->hasFile('photo')) {
        // Hapus foto lama jika ada
        if ($user->photo && Storage::disk('public')->exists($user->photo)) {
            Storage::disk('public')->delete($user->photo);
        }

        // Simpan foto baru di folder public/images/users
        $photo = $request->file('photo');
        $photoName = time() . '_' . $photo->getClientOriginalName();
        $photoPath = $photo->storeAs('images/users', $photoName, 'public');
    }

    // Update data user
    $user->name = $request->name;
    $user->email = $request->email;
    if ($request->filled('password')) {
        $user->password = bcrypt($request->password); // Hash password jika di-update
    }
    $user->role = $request->role;
    $user->photo = $photoPath; // Update path foto baru jika ada
    $user->nomor_absen = $request->nomor_absen; // Update nomor_absen jika ada

    // Simpan perubahan ke database
    if ($user->save()) {
        return response()->json([
            'message' => 'Akun berhasil diperbarui',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'nomor_absen' => $user->nomor_absen, // Sertakan nomor_absen di respons
                'image_url' => $photoPath ? asset('storage/' . $photoPath) : null, // URL foto baru
                'updated_at' => $user->updated_at,
            ]
        ], 200);
    }

    return response()->json(['message' => 'Gagal memperbarui akun'], 500);
}

    
    public function delete(Request $request, $id)
    {
        try {
            $user = User::find($id);
    
            if (!$user) {
                return response()->json([
                    'message' => 'User not found.',
                ], 404);
            }
    
            $username = $user->name; 
    
            $user->delete();
    
            return response()->json([
                'message' => 'Account deleted successfully.',
                'username' => $username,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete account.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    
    
    
    
    
}
