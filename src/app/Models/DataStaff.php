<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DataStaff extends Model
{
    use HasFactory;
    protected $connection = 'mysql';
    protected $table = 'data_staff';
    protected $fillable = ['nama_karyawan', 'kode_pekerja', 'alamat', 'ttl', 'jenis_kelamin', 'jabatan_fungsional'];
}
