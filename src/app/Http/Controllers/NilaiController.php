<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class NilaiController extends Controller
{
    public function index()
    {
        $query = DB::connection('mysql')->table('nilais')->get();
        return response()->json($query, 200);
    }

    public function get_nilai($id)
    {
        $query = DB::connection('mysql')->table('nilais')->where('id', $id)->first();
        if ($query) {
            return response()->json($query, 200);
        } else {
            return response()->json(['message' => 'Data nilai tidak ditemukan'], 404);
        }
    }

    public function create(Request $request)
    {
        $request->validate([
            'mahasiswa_id' => 'required|integer',
            'matakuliah_id' => 'required|integer',
            'tugas' => 'required|numeric',
            'quis' => 'required|numeric',
            'uts' => 'required|numeric',
            'uas' => 'required|numeric',
        ]);

        $dataNilai = DB::connection('mysql')->table('nilais')->insert([
            'mahasiswa_id' => $request->input('mahasiswa_id'),
            'matakuliah_id' => $request->input('matakuliah_id'),
            'tugas' => $request->input('tugas'),
            'quis' => $request->input('quis'),
            'uts' => $request->input('uts'),
            'uas' => $request->input('uas'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        if ($dataNilai) {
            return response()->json(['message' => 'Nilai berhasil di tambahkan !!'], 201);
        } else {
            return response()->json(['message' => 'Gagal menambahkan data nilai'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'mahasiswa_id' => 'sometimes|integer',
            'matakuliah_id' => 'sometimes|integer',
            'tugas' => 'sometimes|numeric',
            'quis' => 'sometimes|numeric',
            'uts' => 'sometimes|numeric',
            'uas' => 'sometimes|numeric',
        ]);
    
        $dataToUpdate = $request->only(['mahasiswa_id', 'matakuliah_id', 'tugas', 'quis', 'uts', 'uas']);
        $dataToUpdate['updated_at'] = now();
    
        $dataNilai = DB::connection('mysql')->table('nilais')->where('id', $id)->update($dataToUpdate);
    
        if ($dataNilai) {
            return response()->json(['message' => 'Nilai berhasil diperbarui !!'], 200);
        } else {
            return response()->json(['message' => 'Gagal memperbarui data nilai'], 500);
        }
    }

    public function delete($id)
    {
        $dataNilai = DB::connection('mysql')->table('nilais')->where('id', $id)->delete();

        if ($dataNilai) {
            return response()->json(['message' => 'Nilai berhasil dihapus !!'], 200);
        } else {
            return response()->json(['message' => 'Gagal menghapus data nilai'], 500);
        }
    }

    
    
}
