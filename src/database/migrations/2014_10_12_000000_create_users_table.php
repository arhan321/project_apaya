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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->enum('role', ['admin', 'siswa','guru','kepala_sekolah','orang_tua'])->default('siswa');
            $table->string('photo')->nullable();
            $table->date('tanggal_lahir')->nullable();
            $table->biginteger('nomor_absen')->nullable();
            $table->biginteger('nisn')->nullable();
            $table->biginteger('nip_guru')->nullable();
            $table->string('kelas')->nullable();
            $table->enum('agama', ['islam', 'kristen','katolik','hindu','budha','konghucu'])->nullable();
            $table->string('wali_murid')->nullable();
            $table->string('wali_kelas')->nullable();
            $table->string('umur')->nullable();
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
