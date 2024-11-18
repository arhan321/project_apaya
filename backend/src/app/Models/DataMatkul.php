<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DataMatkul extends Model
{
    use HasFactory;
    protected $connection = 'mysql';
    protected $table = 'data_matkuls';
    protected $fillable = ['nama_matkul', 'kode_matkul', 'sks', 'semester', 'kurikulum'];

    public function nilai()
    {
        return $this->hasMany(Nilai::class, 'matakuliah_id');
    }
}
