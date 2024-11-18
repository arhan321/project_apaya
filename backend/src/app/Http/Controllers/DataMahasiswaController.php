<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DataMahasiswaController extends Controller
{
    public function index(){
        $query = DB::connection('mysql')->table('data_mahasiswas')->get();
        return response()->json($query, 200);
    }

    public function get_mahasiswa($id){
        $query = DB::connection('mysql')->table('data_mahasiswas')->where('id', $id)->first();
        if($query){
            return response()->json($query, 200);
        } else {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan'], 404);
        }
    }

    public function create(Request $request)
    {
        $request->validate([
            'nama_mahasiswa' => 'nullable|string|max:255',
            'nim' => 'nullable|string|max:255|unique:data_mahasiswas,nim',
            'email' => 'nullable|string|email|max:255|unique:data_mahasiswas,email',
            'ttl' => 'nullable|date_format:Y-m-d H:i:s',
            'jenis_kelamin' => 'nullable|in:laki-laki,perempuan',
            'agama' => 'nullable|in:islam,kristen,katolik,hindu,budha,konghucu',
            'alamat' => 'nullable|string|max:255',
            'fakultas' => 'nullable|in:teknik,ekonomi,hukum,pertanian,perikanan,fasilkom',
            'jurusan' => 'nullable|in:informatika,sipil,mesin,elektro,industri',
            'status' => 'nullable|in:aktif,nonaktif',
        ]);

        $dataMahasiswa = DB::connection('mysql')->table('data_mahasiswas')->insert([
            'nama_mahasiswa' => $request->input('nama_mahasiswa'),
            'nim' => $request->input('nim'),
            'email' => $request->input('email'),
            'ttl' => $request->input('ttl'),
            'jenis_kelamin' => $request->input('jenis_kelamin'),
            'agama' => $request->input('agama'),
            'alamat' => $request->input('alamat'),
            'fakultas' => $request->input('fakultas'),
            'jurusan' => $request->input('jurusan'),
            'status' => $request->input('status'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        if ($dataMahasiswa) {
            return response()->json(['message' => 'Mahasiswa berhasil ditambahkan!'], 201);
        } else {
            return response()->json(['message' => 'Gagal menambahkan data mahasiswa'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $data = $request->validate([
            'nama_mahasiswa' => 'sometimes|required|string|max:255',
            'nim' => 'sometimes|required|string|max:255|unique:data_mahasiswas,nim,' . $id,
            'email' => 'sometimes|required|string|email|max:255|unique:data_mahasiswas,email,' . $id,
            'ttl' => 'sometimes|required|date_format:Y-m-d H:i:s',
            'jenis_kelamin' => 'sometimes|required|in:laki-laki,perempuan',
            'agama' => 'sometimes|required|in:islam,kristen,katolik,hindu,budha,konghucu',
            'alamat' => 'sometimes|required|string|max:255',
            'fakultas' => 'sometimes|required|in:teknik,ekonomi,hukum,pertanian,perikanan,fasilkom',
            'jurusan' => 'sometimes|required|in:informatika,sipil,mesin,elektro,industri',
            'status' => 'sometimes|required|in:aktif,nonaktif',
        ]);

        $data['updated_at'] = now();

        $dataMahasiswa = DB::connection('mysql')->table('data_mahasiswas')->where('id', $id)->update($data);

        if ($dataMahasiswa) {
            return response()->json(['message' => 'Data mahasiswa berhasil diupdate'], 200);
        } else {
            return response()->json(['message' => 'Gagal mengupdate data mahasiswa'], 500);
        }
    }

    public function delete($id)
    {
        $dataMahasiswa = DB::connection('mysql')->table('data_mahasiswas')->where('id', $id)->delete();

        if ($dataMahasiswa) {
            return response()->json(['message' => 'Data mahasiswa berhasil dihapus'], 200);
        } else {
            return response()->json(['message' => 'Gagal menghapus data mahasiswa'], 500);
        }
    }
}
