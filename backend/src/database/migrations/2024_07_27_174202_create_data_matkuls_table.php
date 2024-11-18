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
        Schema::create('data_matkuls', function (Blueprint $table) {
            $table->id();
            $table->string('nama_matkul');
            $table->string('kode_matkul');
            $table->string('sks');
            $table->string('semester');
            $table->string('kurikulum');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_matkuls');
    }
};
