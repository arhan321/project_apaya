<?php

namespace App\Http\Controllers;

// use Storage;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
// use Illuminate\Support\Facades\Storage;
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
            // Regenerasi session untuk keamanan
            $request->session()->regenerate();
    
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
            'nomor_absen' => 'nullable|integer|min:1|required_if:role,siswa', // Hanya siswa yang memerlukan nomor absen
        ]);
    
        // Mengatur upload gambar jika ada
        $imagePath = null;
        if ($request->hasFile('photo')) {
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
                'photo' => $imagePath,
                'nomor_absen' => $request->nomor_absen,
            ]);
    
            // Jika user berhasil dibuat
            return response()->json([
                'message' => 'Akun berhasil terdaftar!',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'nomor_absen' => $user->nomor_absen,
                    'image_url' => $imagePath ? Storage::url($imagePath) : null,
                ],
            ], 201);
    
        } catch (QueryException $e) {
            return response()->json([
                'message' => 'Kesalahan database: ' . $e->getMessage(),
            ], 500);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan: ' . $e->getMessage(),
            ], 500);
        }
    }
    
    
    

    public function logout(Request $request)
    {
        Auth::logout();
    
        $request->session()->invalidate();
    
        $request->session()->regenerateToken();
    
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
        $query = DB::connection('mysql')->table('user')->where('id', $id)->first();
        if ($query) {
            return response()->json($query, 200);
        } else {
            return response()->json(['message' => 'Data tidak di temukan'], 404);
        }
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
    
    public function getLoggedInUser()
{
    // Verifikasi apakah pengguna login
    if (Auth::check()) {
        $user = Auth::user();

        // Berikan respons data pengguna
        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'image_url' => $user->photo ? asset('storage/' . $user->photo) : null,
            'nomor_absen' => $user->nomor_absen,
        ], 200);
    } else {
        // Berikan respons jika pengguna tidak login
        return response()->json(['message' => 'Unauthorized: User not logged in'], 401);
    }
}
    
    
    
    
}
