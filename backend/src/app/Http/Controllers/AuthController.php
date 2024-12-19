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
                    'image_url' => $imagePath ? Storage::url($imagePath) : null,
                ],
                'token' => $token, // Token ditambahkan ke response
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
            'name' => 'nullable|string|max:255',
            'email' => 'nullable|string|email|max:255',
            'password' => 'nullable|string|min:8',
            'role' => 'nullable|string|in:admin,siswa,guru,orang_tua,kepala_sekolah',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240',
            'nomor_absen' => 'nullable|integer|min:1', // Validasi nomor_absen
        ]);
    
        // Cari user berdasarkan ID
        $user = User::find($id);
        if (!$user) {
            Log::info("User not found with ID: $id");
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }
    
        // Cek duplikat username atau email
        $existingUser = User::where(function ($query) use ($request, $id) {
            $query->where('email', $request->email)
                  ->orWhere('name', $request->name);
        })->where('id', '!=', $id)->first();
    
        if ($existingUser) {
            Log::info("Duplicate found for email or name: {$request->email} / {$request->name}");
            return response()->json(['message' => 'Username atau email sudah digunakan oleh user lain'], 400);
        }
    
        // Foto baru (jika ada) akan diupdate
        $photoPath = $user->photo; // Gunakan foto lama jika tidak ada yang di-upload
        if ($request->hasFile('photo')) {
            // Hapus foto lama jika ada
            if ($user->photo && Storage::disk('public')->exists($user->photo)) {
                Storage::disk('public')->delete($user->photo);
                Log::info("Old photo deleted: {$user->photo}");
            }
    
            // Simpan foto baru
            $photo = $request->file('photo');
            $photoName = time() . '_' . $photo->getClientOriginalName();
            $photoPath = $photo->storeAs('images/users', $photoName, 'public');
            Log::info("New photo saved: $photoPath");
        }
    
        // Debugging: Log the incoming request data
        Log::info('Request data received:', $request->all());
    
        // Hanya update jika ada perubahan
        $updatedFields = [];
        if ($request->has('name') && $request->name != $user->name) {
            $user->name = $request->name;
            $updatedFields[] = 'name';
        }
    
        if ($request->has('email') && $request->email != $user->email) {
            $user->email = $request->email;
            $updatedFields[] = 'email';
        }
    
        if ($request->filled('password')) {
            $user->password = bcrypt($request->password); // Hash password jika di-update
            $updatedFields[] = 'password';
        }
    
        if ($request->has('role') && $request->role != $user->role) {
            $user->role = $request->role;
            $updatedFields[] = 'role';
        }
    
        if ($request->has('nomor_absen') && $request->nomor_absen != $user->nomor_absen) {
            $user->nomor_absen = $request->nomor_absen;
            $updatedFields[] = 'nomor_absen';
        }
    
        // Foto yang baru
        $user->photo = $photoPath;
    
        // Simpan perubahan ke database jika ada perubahan
        if (count($updatedFields) > 0) {
            if ($user->save()) {
                Log::info("User updated successfully. Updated fields: " . implode(', ', $updatedFields));
                return response()->json([
                    'message' => 'Akun berhasil diperbarui',
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'role' => $user->role,
                        'nomor_absen' => $user->nomor_absen,
                        'image_url' => $photoPath ? asset('storage/' . $photoPath) : null, // URL foto baru
                        'updated_at' => $user->updated_at,
                    ]
                ], 200);
            }
        } else {
            Log::info("No changes detected for user ID: $id");
            return response()->json(['message' => 'No changes detected'], 400);
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
    
    public function getLoggedInUser(Request $request)
{
    // Verifikasi apakah pengguna login
    if (Auth::check()) {
        $user = Auth::user();

        // Ambil token aktif pengguna (jika menggunakan Sanctum)
        $currentToken = $request->bearerToken();

        // Berikan respons data pengguna bersama token
        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'image_url' => $user->photo ? asset('storage/' . $user->photo) : null,
            'nomor_absen' => $user->nomor_absen,
            'token' => $currentToken, // Sertakan token dalam respons
        ], 200);
    }

    // Berikan respons jika pengguna tidak login
    return response()->json(['message' => 'Unauthorized: User not logged in'], 401);
}


    
    
    
    
}
