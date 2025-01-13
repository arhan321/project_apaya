<?php

namespace App\Http\Controllers;

use App\Models\DataKelas;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class DataKelasController extends Controller
{
    // READ: Lihat Semua Data Kelas
    public function index()
    {
        Log::info('Request untuk mendapatkan semua data kelas diterima.');
    
        try {
            // Ambil data kelas dengan relasi user
            $dataKelas = DataKelas::with('user')->get();
    
            // Modifikasi data untuk hanya mengambil nama user
            $dataKelas = $dataKelas->map(function ($kelas) {
                return [
                    'id' => $kelas->id,
                    'user_id' => $kelas->user_id,
                    'nama_user' => $kelas->user ? $kelas->user->name : null, // Ambil nama user
                    'nama_kelas' => $kelas->nama_kelas,
                    'tanggal_absen' => $kelas->tanggal_absen,
                    'siswa' => $kelas->siswa,
                ];
            });
    
            Log::info('Semua data kelas berhasil diambil.', ['data' => $dataKelas]);
    
            return response()->json([
                'message' => 'Data kelas berhasil diambil',
                'data' => $dataKelas
            ], 200);
        } catch (\Exception $e) {
            Log::error('Gagal mendapatkan data kelas.', ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil data kelas',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    

    // CREATE: membuat data kelas baru
    public function store(Request $request)
    {
        Log::info('Metode POST Data diterima.', [
            'request_headers' => $request->headers->all(),
            'request_body' => $request->except(['password', 'token']),
        ]);
    
        // Validasi input
        $validated = $request->validate([
            'user_id' => 'nullable|exists:users,id',
            'nama_kelas' => 'required|string|max:255',
            'tanggal_absen' => 'nullable|date',
            'siswa' => 'nullable|array',
            'siswa.*.id' => 'required_with:siswa|integer', // Validasi ID siswa
            'siswa.*.nama' => 'required_with:siswa|string|max:255',
            'siswa.*.nomor_absen' => 'nullable|string|max:50',
            'siswa.*.kelas' => 'nullable|string|max:100',
            'siswa.*.keterangan' => 'nullable|string|max:50',
            'siswa.*.jam_absen' => 'nullable|string|max:10',
            'siswa.*.catatan' => 'nullable|string|max:255', // Validasi catatan
        ]);
    
        try {
            // Pastikan siswa memiliki format JSON yang valid
            $validated['siswa'] = $validated['siswa'] ?? [];
            foreach ($validated['siswa'] as $siswa) {
                if (!isset($siswa['nama']) || empty($siswa['nama'])) {
                    throw new \Exception('Setiap siswa harus memiliki nama.');
                }
            }
    
            // Simpan data kelas
            $dataKelas = DataKelas::create([
                'user_id' => $validated['user_id'] ?? null,
                'nama_kelas' => $validated['nama_kelas'],
                'tanggal_absen' => $validated['tanggal_absen'] ?? null,
                'siswa' => json_encode($validated['siswa']), // Simpan siswa dengan ID
            ]);
    
            Log::info('Data kelas berhasil ditambahkan.', [
                'data' => $dataKelas,
            ]);
    
            return response()->json([
                'message' => 'Data kelas berhasil ditambahkan',
                'data' => [
                    'id' => $dataKelas->id,
                    'nama_kelas' => $dataKelas->nama_kelas,
                    'tanggal_absen' => $dataKelas->tanggal_absen,
                    'siswa' => json_decode($dataKelas->siswa, true), // Decode JSON siswa
                ],
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('Gagal menambahkan data kelas.', [
                'error' => $e->getMessage(),
            ]);
    
            return response()->json([
                'message' => 'Gagal menambahkan data kelas',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    

    
    // READ: Lihat Detail Data Kelas Berdasarkan ID
    public function show($id)
    {
        Log::info("Request untuk mendapatkan data kelas dengan ID $id diterima.");

        try {
            $dataKelas = DataKelas::find($id);

            if (!$dataKelas) {
                Log::warning("Data kelas dengan ID $id tidak ditemukan.");
                return response()->json([
                    'message' => 'Data kelas tidak ditemukan'
                ], 404);
            }

            Log::info("Data kelas dengan ID $id berhasil ditemukan.", ['data' => $dataKelas]);

            return response()->json([
                'message' => 'Data kelas berhasil ditemukan',
                'data' => $dataKelas
            ], 200);
        } catch (\Exception $e) {
            Log::error('Gagal mendapatkan detail data kelas.', ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil detail data kelas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // UPDATE: Perbarui Data Kelas
    public function update(Request $request, $id)
    {
        Log::info("Memperbarui data kelas dengan ID $id", [
            'request_data' => $request->except(['password', 'token']),
        ]);
    
        // Cari data kelas berdasarkan ID
        $dataKelas = DataKelas::with('user')->find($id);
    
        if (!$dataKelas) {
            Log::warning("Data kelas dengan ID $id tidak ditemukan.");
            return response()->json([
                'message' => 'Data kelas tidak ditemukan'
            ], 404);
        }
    
        // Validasi input
        $validated = $request->validate([
            'nama_kelas' => 'sometimes|nullable|string|max:255',
            'user_id' => 'sometimes|nullable|exists:users,id',
            'tanggal_absen' => 'sometimes|nullable|date',
            'siswa' => 'sometimes|nullable|array',
            'siswa.*.id' => 'required_with:siswa|integer',
            'siswa.*.nama' => 'required_with:siswa|string|max:255',
            'siswa.*.nomor_absen' => 'sometimes|string|max:50',
            'siswa.*.kelas' => 'sometimes|string|max:100',
            'siswa.*.keterangan' => 'sometimes|string|max:50',
            'siswa.*.jam_absen' => 'sometimes|string|max:10',
            'siswa.*.catatan' => 'sometimes|string|max:255',
        ]);
    
        try {
            // Decode JSON siswa yang ada di database
            $existingSiswa = $dataKelas->siswa && is_string($dataKelas->siswa)
                ? json_decode($dataKelas->siswa, true)
                : [];
    
            // Proses pembaruan siswa berdasarkan ID
            $updatedSiswa = collect($existingSiswa)->map(function ($siswa) use ($validated) {
                // Cek apakah siswa ini ada di data yang dikirimkan
                $updatedData = collect($validated['siswa'] ?? [])
                    ->firstWhere('id', $siswa['id']);
                
                // Jika ada, perbarui datanya
                return $updatedData ? array_merge($siswa, $updatedData) : $siswa;
            })->values()->toArray();
    
            // Tambahkan siswa baru yang tidak ada di existingSiswa
            $newSiswa = collect($validated['siswa'] ?? [])
                ->reject(fn($siswa) => collect($existingSiswa)->pluck('id')->contains($siswa['id']))
                ->toArray();
    
            $updatedSiswa = array_merge($updatedSiswa, $newSiswa);
    
            // Update data kelas
            $data = [
                'nama_kelas' => $validated['nama_kelas'] ?? $dataKelas->nama_kelas,
                'user_id' => $validated['user_id'] ?? $dataKelas->user_id,
                'tanggal_absen' => $validated['tanggal_absen'] ?? $dataKelas->tanggal_absen,
                'siswa' => json_encode($updatedSiswa),
            ];
    
            // Hapus entri null dari array untuk efisiensi
            $data = array_filter($data, fn($value) => !is_null($value));
    
            $dataKelas->update($data);
    
            // Muat ulang relasi user untuk mengembalikan data terkini
            $dataKelas->load('user:id,name');
    
            Log::info("Data kelas dengan ID $id berhasil diperbarui.", [
                'updated_data' => $data,
                'updated_siswa' => $updatedSiswa,
            ]);
    
            return response()->json([
                'message' => 'Data kelas berhasil diperbarui',
                'data' => [
                    'id' => $dataKelas->id,
                    'nama_kelas' => $dataKelas->nama_kelas,
                    'user_id' => $dataKelas->user_id,
                    'nama_user' => $dataKelas->user ? $dataKelas->user->name : null,
                    'tanggal_absen' => $dataKelas->tanggal_absen,
                    'siswa' => $updatedSiswa,
                ],
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $e->errors(),
            ], 422);
        } catch (QueryException $e) {
            Log::error("Database error saat memperbarui data kelas dengan ID $id.", [
                'error' => $e->getMessage(),
            ]);
    
            return response()->json([
                'message' => 'Terjadi kesalahan pada database',
                'error' => $e->getMessage(),
            ], 500);
        } catch (\Exception $e) {
            Log::error("Gagal memperbarui data kelas dengan ID $id.", [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
    
            return response()->json([
                'message' => 'Terjadi kesalahan saat memperbarui data kelas',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function updateSiswa(Request $request, $id)
{
    Log::info("Memperbarui data siswa pada kelas dengan ID $id", [
        'request_data' => $request->except(['password', 'token']),
    ]);

    // Cari data kelas berdasarkan ID
    $dataKelas = DataKelas::find($id);

    if (!$dataKelas) {
        Log::warning("Data kelas dengan ID $id tidak ditemukan.");
        return response()->json([
            'message' => 'Data kelas tidak ditemukan'
        ], 404);
    }

    // Validasi input
    $validated = $request->validate([
        'siswa' => 'required|array',
        'siswa.*.id' => 'required|integer',
        'siswa.*.nama' => 'required|string|max:255',
        'siswa.*.nomor_absen' => 'sometimes|string|max:50',
        'siswa.*.kelas' => 'sometimes|string|max:100',
        'siswa.*.keterangan' => 'sometimes|string|max:50',
        'siswa.*.jam_absen' => 'sometimes|string|max:10',
        'siswa.*.catatan' => 'sometimes|string|max:255',
    ]);

    try {
        // Decode JSON siswa yang ada di database
        $existingSiswa = $dataKelas->siswa && is_string($dataKelas->siswa)
            ? json_decode($dataKelas->siswa, true)
            : [];

        // Proses pembaruan siswa berdasarkan ID
        $updatedSiswa = collect($existingSiswa)->map(function ($siswa) use ($validated) {
            // Cek apakah siswa ini ada di data yang dikirimkan
            $updatedData = collect($validated['siswa'])
                ->firstWhere('id', $siswa['id']);
            
            // Jika ada, perbarui datanya
            return $updatedData ? array_merge($siswa, $updatedData) : $siswa;
        })->values()->toArray();

        // Tambahkan siswa baru yang tidak ada di existingSiswa
        $newSiswa = collect($validated['siswa'])
            ->reject(fn($siswa) => collect($existingSiswa)->pluck('id')->contains($siswa['id']))
            ->toArray();

        $updatedSiswa = array_merge($updatedSiswa, $newSiswa);

        // Update field siswa di data kelas
        $dataKelas->update([
            'siswa' => json_encode($updatedSiswa),
        ]);

        Log::info("Data siswa pada kelas dengan ID $id berhasil diperbarui.", [
            'updated_siswa' => $updatedSiswa,
        ]);

        return response()->json([
            'message' => 'Data siswa berhasil diperbarui',
            'data' => $updatedSiswa,
        ], 200);
    } catch (ValidationException $e) {
        return response()->json([
            'message' => 'Validasi gagal',
            'errors' => $e->errors(),
        ], 422);
    } catch (QueryException $e) {
        Log::error("Database error saat memperbarui data siswa pada kelas dengan ID $id.", [
            'error' => $e->getMessage(),
        ]);

        return response()->json([
            'message' => 'Terjadi kesalahan pada database',
            'error' => $e->getMessage(),
        ], 500);
    } catch (\Exception $e) {
        Log::error("Gagal memperbarui data siswa pada kelas dengan ID $id.", [
            'error' => $e->getMessage(),
            'trace' => $e->getTraceAsString(),
        ]);

        return response()->json([
            'message' => 'Terjadi kesalahan saat memperbarui data siswa',
            'error' => $e->getMessage(),
        ], 500);
    }
}

    

    // DELETE: Hapus Data Kelas
    public function destroy($id)
    {
        Log::info("Request untuk menghapus data kelas dengan ID $id diterima.");

        try {
            $dataKelas = DataKelas::find($id);

            if (!$dataKelas) {
                Log::warning("Data kelas dengan ID $id tidak ditemukan untuk dihapus.");
                return response()->json([
                    'message' => 'Data kelas tidak ditemukan'
                ], 404);
            }

            $dataKelas->delete();

            Log::info("Data kelas dengan ID $id berhasil dihapus.");

            return response()->json([
                'message' => 'Data kelas berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            Log::error("Gagal menghapus data kelas dengan ID $id.", ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Terjadi kesalahan saat menghapus data kelas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function deleteSiswa(Request $request, $id)
{
    Log::info("Menghapus data siswa dalam kelas dengan ID $id", [
        'request_data' => $request->all(),
    ]);

    // Validasi input
    $validated = $request->validate([
        'siswa_id' => 'required|integer', // ID siswa yang akan dihapus
    ]);

    // Cari data kelas berdasarkan ID
    $dataKelas = DataKelas::find($id);

    if (!$dataKelas) {
        Log::warning("Data kelas dengan ID $id tidak ditemukan.");
        return response()->json([
            'message' => 'Data kelas tidak ditemukan'
        ], 404);
    }

    try {
        // Decode JSON siswa
        $siswaData = $dataKelas->siswa && is_string($dataKelas->siswa)
            ? json_decode($dataKelas->siswa, true)
            : [];

        // Filter siswa berdasarkan ID
        $filteredSiswa = collect($siswaData)->reject(function ($siswa) use ($validated) {
            return $siswa['id'] == $validated['siswa_id'];
        })->values()->toArray();

        // Update data kelas dengan siswa yang sudah difilter
        $dataKelas->update([
            'siswa' => json_encode($filteredSiswa),
        ]);

        Log::info("Siswa dengan ID {$validated['siswa_id']} berhasil dihapus dari kelas dengan ID $id.", [
            'updated_siswa' => $filteredSiswa,
        ]);

        return response()->json([
            'message' => 'Data siswa berhasil dihapus',
            'data' => [
                'id' => $dataKelas->id,
                'nama_kelas' => $dataKelas->nama_kelas,
                'siswa' => $filteredSiswa,
            ],
        ], 200);
    } catch (\Exception $e) {
        Log::error("Gagal menghapus data siswa dari kelas dengan ID $id.", [
            'error' => $e->getMessage(),
            'trace' => $e->getTraceAsString(),
        ]);

        return response()->json([
            'message' => 'Terjadi kesalahan saat menghapus data siswa',
            'error' => $e->getMessage(),
        ], 500);
    }
}

}
