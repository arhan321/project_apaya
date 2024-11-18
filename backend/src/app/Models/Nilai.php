<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Nilai extends Model
{
    use HasFactory;
    protected $connection = 'mysql';
    protected $table = 'nilais';
    protected $fillable = ['mahasiswa_id', 'matakuliah_id', 'tugas', 'quis', 'uts', 'uas'];

    public function mahasiswa()
    {
        return $this->belongsTo(DataMahasiswa::class, 'mahasiswa_id');
    }
}
