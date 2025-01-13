<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DataKelas extends Model
{
    protected $table = 'data_kelas';
    protected $fillable = [
        'user_id',
        'nama_kelas',
        'tanggal_absen',
        'siswa'
    ];
    protected $casts = [
        'siswa' => 'array'
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
