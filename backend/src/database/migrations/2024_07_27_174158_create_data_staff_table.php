<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('data_staff', function (Blueprint $table) {
            $table->id();
            $table->string('nama_karyawan');
            $table->string('kode_pekerja');
            $table->string('email');
            $table->dateTime('ttl');
            $table->string('alamat');
            $table->enum('agama', ['islam', 'kristen', 'katolik', 'hindu', 'budha', 'konghucu']);
            $table->enum('jenis_kelamin', ['laki-laki', 'perempuan']);
            $table->string('jabatan_fungsional');
            $table->enum('status', ['aktif', 'nonaktif']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_staff');
    }
};
