<?php

namespace App\Http\Controllers;

// use Storage;
// use Log;
use Log;
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
        // Validasi input
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors(),
            ], 422);
        }
    
        // Periksa kredensial
        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $request->session()->regenerate();
    
            $user = Auth::user();
    
            // Buat token untuk pengguna
            $token = $user->createToken('auth_token')->plainTextToken;
    
            return response()->json([
                'message' => 'Login successful',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                ],
                'token' => $token,
            ], 200);
        }
    
        // Log unauthorized login
        \Log::warning('Unauthorized login attempt', [
            'email' => $request->email
        ]);
    
        return response()->json([
            'message' => 'Unauthorized, wrong email or password',
        ], 401);
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
        'nomor_absen' => 'nullable|integer|min:1|required_if:role,siswa',
        'tanggal_lahir' => 'nullable|date', // Tambahkan validasi untuk tanggal lahir
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
            'tanggal_lahir' => $request->tanggal_lahir, // Simpan tanggal lahir
        ]);

        // Membuat token untuk pengguna yang baru terdaftar
        $token = $user->createToken('auth_token')->plainTextToken;

        // Jika user berhasil dibuat
        return response()->json([
            'message' => 'Akun berhasil terdaftar!',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'nomor_absen' => $user->nomor_absen,
                'tanggal_lahir' => $user->tanggal_lahir, // Tanggal lahir ditambahkan ke respons
                'image_url' => $imagePath ? Storage::url($imagePath) : null,
            ],
            'token' => $token,
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
        Auth::guard('sanctum')->logout(); // Log out using Sanctum

        // Invalidate session
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json(['message' => 'Logout successful'], 200);
    }


    public function index(Request $request)
    {
        // Periksa apakah permintaan berasal dari browser
        $userAgent = $request->headers->get('User-Agent');
        if ($userAgent && preg_match('/Mozilla|Chrome|Safari/', $userAgent)) {
            return abort(404); // Balikan 404 jika berasal dari browser
        }
    
        $query = DB::connection('mysql')->table('users')->get();
    
        // Map setiap item untuk menambahkan image_url
        $data = $query->map(function ($item) {
            if ($item->photo) {
                // Buat URL lengkap untuk photo menggunakan asset helper
                $item->image_url = asset('storage/' . $item->photo);
            } else {
                // Jika tidak ada photo, set ke null
                $item->image_url = null;
            }
            return $item;
        });
    
        // Cek jika data kosong
        if ($data->isEmpty()) {
            return response()->json([
                'message' => 'Tidak ada data pengguna.',
            ], 200);
        }
    
        // Kembalikan data dengan image_url
        return response()->json($data, 200);
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
            'name' => 'nullable|string|max:255',
            'email' => 'nullable|string|email|max:255',
            'password' => 'nullable|string|min:8',
            'role' => 'nullable|string|in:admin,siswa,guru,orang_tua,kepala_sekolah',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:102400', // Maksimum 100 MB
            'nomor_absen' => 'nullable|integer|min:1',
            'tanggal_lahir' => 'nullable|date', // Validasi tanggal lahir
        ]);
    
        // Cari user berdasarkan ID
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }
    
        // Update data user jika ada perubahan
        $user->name = $request->name ?? $user->name;
        $user->email = $request->email ?? $user->email;
        $user->role = $request->role ?? $user->role;
        $user->nomor_absen = $request->nomor_absen ?? $user->nomor_absen;
        $user->tanggal_lahir = $request->tanggal_lahir ?? $user->tanggal_lahir;
    
        // Password dihash jika diperbarui
        if ($request->filled('password')) {
            $user->password = bcrypt($request->password);
        }
    
        // Update foto jika ada
        if ($request->hasFile('photo')) {
            $photo = $request->file('photo');
            $photoName = time() . '_' . $photo->getClientOriginalName();
            $photoPath = $photo->storeAs('images/users', $photoName, 'public');
    
            // Hapus foto lama jika ada
            if ($user->photo && Storage::disk('public')->exists($user->photo)) {
                Storage::disk('public')->delete($user->photo);
            }
    
            $user->photo = $photoPath;
        }
    
        // Simpan perubahan
        if ($user->save()) {
            return response()->json([
                'message' => 'Akun berhasil diperbarui',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'nomor_absen' => $user->nomor_absen,
                    'tanggal_lahir' => $user->tanggal_lahir,
                    'image_url' => $user->photo ? asset('storage/' . $user->photo) : null,
                ]
            ], 200);
        }
    
        return response()->json(['message' => 'Gagal memperbarui akun'], 500);
    }
    
    
    public function uploadPhoto(Request $request, $id)
{
    // Validasi input
    $request->validate([
        'photo' => 'required|image|mimes:jpeg,png,jpg,gif|max:10240', // Maks 10MB
    ]);

    // Cari user berdasarkan ID
    $user = User::find($id);
    if (!$user) {
        return response()->json(['message' => 'User not found'], 404);
    }

    // Proses unggah file
    if ($request->hasFile('photo')) {
        $photo = $request->file('photo');
        $photoName = time() . '_' . $photo->getClientOriginalName();
        $photoPath = $photo->storeAs('images/users', $photoName, 'public');

        // Update field photo di database
        $user->photo = $photoPath;
        $user->save();

        return response()->json([
            'message' => 'Photo uploaded successfully',
            'photo_url' => asset('storage/' . $photoPath),
        ], 200);
    }

    return response()->json(['message' => 'Photo upload failed'], 400);
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
    
    public function getLoggedInUser(Request $request)
    {
        if (Auth::check()) {
            $user = Auth::user();
            $currentToken = $request->bearerToken();
    
            return response()->json([
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'nomor_absen' => $user->nomor_absen,
                'tanggal_lahir' => $user->tanggal_lahir, // Tanggal lahir ditambahkan ke respons
                'image_url' => $user->photo ? asset('storage/' . $user->photo) : null,
                'token' => $currentToken,
            ], 200);
        }
    
        return response()->json(['message' => 'Unauthorized: User not logged in'], 401);
    }
    



    
}
