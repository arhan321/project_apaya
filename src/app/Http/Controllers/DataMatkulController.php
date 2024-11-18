<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DataMatkulController extends Controller
{
    public function index(){
        $query = DB::connection('mysql')->table('data_matkuls')->get();
        return response()->json($query, 200);
    }

   
    public function create(Request $request)
    {
        $request->validate([
            'nama_matkul' => 'required|string|max:255',
            'kode_matkul' => 'required|string|max:255|unique:data_matkuls,kode_matkul',
            'sks' => 'required|string|max:10',
            'semester' => 'required|string|max:10',
            'kurikulum' => 'required|string|max:255',
        ]);

        $dataMatkul = DB::connection('mysql')->table('data_matkuls')->insert([
            'nama_matkul' => $request->input('nama_matkul'),
            'kode_matkul' => $request->input('kode_matkul'),
            'sks' => $request->input('sks'),
            'semester' => $request->input('semester'),
            'kurikulum' => $request->input('kurikulum'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        if ($dataMatkul) {
            return response()->json(['message' => 'Mata kuliah berhasil ditambahkan!'], 201);
        } else {
            return response()->json(['message' => 'Gagal menambahkan data mata kuliah'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $data = $request->validate([
            'nama_matkul' => 'sometimes|required|string|max:255',
            'kode_matkul' => 'sometimes|required|string|max:255|unique:data_matkuls,kode_matkul,' . $id,
            'sks' => 'sometimes|required|string|max:10',
            'semester' => 'sometimes|required|string|max:10',
            'kurikulum' => 'sometimes|required|string|max:255',
        ]);

        $dataMatkul = DB::connection('mysql')->table('data_matkuls')->where('id', $id)->update($data);

        if ($dataMatkul) {
            return response()->json(['message' => 'Mata kuliah berhasil diupdate!'], 200);
        } else {
            return response()->json(['message' => 'Gagal mengupdate data mata kuliah'], 500);
        }
    }

    public function get_matkul($id) {
        $query = DB::connection('mysql')->table('data_matkuls')->where('id', $id)->first();
        
        if ($query) {
            return response()->json($query, 200); 
        } else {
            return response()->json(['message' => 'Data matkul tidak ditemukan'], 404);
        }
    }

    public function delete($id){
        $query = DB::connection('mysql')->table('data_matkuls')->where('id', $id)->delete();
        if($query){
            return response()->json(['message' => 'Data mata kuliah berhasil dihapus'], 200);
        } else {
            return response()->json(['message' => 'Gagal menghapus data mata kuliah'], 500);
        }
    }

}
