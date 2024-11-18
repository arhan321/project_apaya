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
        Schema::create('nilais', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('mahasiswa_id');
            $table->unsignedBigInteger('matakuliah_id');
            $table->string('tugas');
            $table->string('quis');
            $table->string('uts');
            $table->string('uas');
            $table->timestamps();
            
            $table->foreign('mahasiswa_id')->references('id')->on('data_mahasiswas');
            $table->foreign('matakuliah_id')->references('id')->on('data_matkuls');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('nilais');
    }
};
