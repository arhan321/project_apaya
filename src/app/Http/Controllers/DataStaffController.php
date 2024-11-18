<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DataStaffController extends Controller
{
    public function index(){
        $query = DB::connection('mysql')->table('data_staff')->get();
        return response()->json($query, 200);
    }

    public function get_staff($id){
        $query = DB::connection('mysql')->table('data_staff')->where('id', $id)->first();
        if($query){
            return response()->json($query, 200);
        } else {
            return response()->json(['message' => 'Data staff tidak ditemukan'], 404);
        }
    }

    public function create(Request $request)
    {
        $request->validate([
            'nama_karyawan' => 'nullable|string|max:255|unique:data_staff,nama_karyawan',
            'kode_pekerja' => 'nullable|string|max:100|unique:data_staff,kode_pekerja',
            'email' => 'nullable|string|email|max:255|unique:data_staff,email',
            'ttl' => 'nullable|date_format:Y-m-d H:i:s',
            'jenis_kelamin' => 'nullable|in:laki-laki,perempuan',
            'agama' => 'nullable|in:islam,kristen,katolik,hindu,budha,konghucu',
            'alamat' => 'nullable|string|max:255',
            'jabatan_fungsional' => 'nullable|string|max:255',
            'status' => 'nullable|in:aktif,nonaktif',
        ]);
    
        $dataStaff = DB::connection('mysql')->table('data_staff')->insert([
            'nama_karyawan' => $request->input('nama_karyawan'),
            'kode_pekerja' => $request->input('kode_pekerja'),
            'email' => $request->input('email'),
            'ttl' => $request->input('ttl'),
            'jenis_kelamin' => $request->input('jenis_kelamin'),
            'agama' => $request->input('agama'),
            'alamat' => $request->input('alamat'),
            'jabatan_fungsional' => $request->input('jabatan_fungsional'),
            'status' => $request->input('status'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    
        if ($dataStaff) {
            return response()->json(['message' => 'Staff berhasil ditambahkan!'], 201);
        } else {
            return response()->json(['message' => 'Gagal menambahkan data staff'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'nama_karyawan' => 'sometimes|string|max:255|unique:data_staff,nama_karyawan,' . $id,
            'kode_pekerja' => 'sometimes|string|max:100|unique:data_staff,kode_pekerja,' . $id,
            'email' => 'sometimes|string|email|max:255|unique:data_staff,email,' . $id,
            'ttl' => 'sometimes|date_format:Y-m-d H:i:s',
            'jenis_kelamin' => 'sometimes|in:laki-laki,perempuan',
            'agama' => 'sometimes|in:islam,kristen,katolik,hindu,budha,konghucu',
            'alamat' => 'sometimes|string|max:255',
            'jabatan_fungsional' => 'sometimes|string|max:255',
            'status' => 'sometimes|in:aktif,nonaktif',
        ]);
    
        $data = $request->only([
            'nama_karyawan', 'kode_pekerja', 'email', 'ttl', 'jenis_kelamin', 
            'agama', 'alamat', 'jabatan_fungsional', 'status'
        ]);
        $data['updated_at'] = now();
    
        $dataStaff = DB::connection('mysql')->table('data_staff')->where('id', $id)->update($data);
    
        if ($dataStaff) {
            return response()->json(['message' => 'Data staff berhasil diperbarui!'], 200);
        } else {
            return response()->json(['message' => 'Gagal memperbarui data staff'], 500);
        }
    }

    public function delete($id)
    {
        $dataStaff = DB::connection('mysql')->table('data_staff')->where('id', $id)->delete();

        if ($dataStaff) {
            return response()->json(['message' => 'Data staff berhasil dihapus!'], 200);
        } else {
            return response()->json(['message' => 'Gagal menghapus data staff'], 500);
        }
    }
}
