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
            $dataKelas = DataKelas::all();

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
        // Log untuk debugging awal
        Log::info('Metode POST Data diterima.', ['request_headers' => $request->headers->all(), 'request_body' => $request->all()]);
    
        // Validasi data
        $validated = $request->validate([
            'user_id' => 'nullable|exists:users,id',
            'nama_kelas' => 'required|string|max:255',
            'tanggal_absen' => 'nullable|date',
            'siswa' => 'nullable|array', // Pastikan siswa adalah array
            'siswa.*.nama' => 'required|string|max:255',
            'siswa.*.nomor_absen' => 'required|string|max:50',
            'siswa.*.kelas' => 'required|string|max:100',
            'siswa.*.keterangan' => 'required|string|max:50',
            'siswa.*.jam_absen' => 'required|string|max:10'
        ]);
    
        try {
            // Buat data kelas
            $dataKelas = DataKelas::create([
                'user_id' => $validated['user_id'] ?? null,
                'nama_kelas' => $validated['nama_kelas'],
                'tanggal_absen' => $validated['tanggal_absen'] ?? null,
                'siswa' => json_encode($validated['siswa']), // Konversi array siswa ke JSON
            ]);
    
            Log::info('Data kelas berhasil ditambahkan.', ['data' => $dataKelas]);
    
            return response()->json([
                'message' => 'Data kelas berhasil ditambahkan',
                'data' => $dataKelas
            ], 201);
        } catch (\Exception $e) {
            Log::error('Gagal menambahkan data kelas.', ['error' => $e->getMessage()]);
    
            return response()->json([
                'message' => 'Gagal menambahkan data kelas',
                'error' => $e->getMessage()
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
    Log::info("Request untuk memperbarui data kelas dengan ID $id diterima.", ['request' => $request->all()]);

    $validated = $request->validate([
        'siswa' => 'required|array', // Pastikan siswa adalah array
        'siswa.*.nama' => 'required|string|max:255',
        'siswa.*.nomor_absen' => 'required|string|max:50',
        'siswa.*.kelas' => 'required|string|max:100',
        'siswa.*.keterangan' => 'required|string|max:50',
        'siswa.*.jam_absen' => 'required|string|max:10'
    ]);

    try {
        // Cari data kelas berdasarkan ID
        $dataKelas = DataKelas::find($id);

        if (!$dataKelas) {
            Log::warning("Data kelas dengan ID $id tidak ditemukan untuk diperbarui.");
            return response()->json([
                'message' => 'Data kelas tidak ditemukan'
            ], 404);
        }

        // Decode JSON siswa yang sudah ada di database
        $existingSiswa = $dataKelas->siswa ? json_decode($dataKelas->siswa, true) : [];

        // Gabungkan siswa baru dengan siswa yang sudah ada
        $updatedSiswa = array_merge($existingSiswa, $validated['siswa']);

        // Update data kelas dengan daftar siswa baru
        $dataKelas->update([
            'siswa' => json_encode($updatedSiswa)
        ]);

        Log::info("Data kelas dengan ID $id berhasil diperbarui.", ['data' => $dataKelas]);

        return response()->json([
            'message' => 'Data kelas berhasil diperbarui',
            'data' => $dataKelas
        ], 200);
    } catch (\Exception $e) {
        Log::error("Gagal memperbarui data kelas dengan ID $id.", ['error' => $e->getMessage()]);

        return response()->json([
            'message' => 'Terjadi kesalahan saat memperbarui data kelas',
            'error' => $e->getMessage()
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
}
