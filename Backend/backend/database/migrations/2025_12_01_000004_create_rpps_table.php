<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rpps', function (Blueprint $table) {
            $table->id('rpp_id');
            $table->string('nama_mata_pelajaran');
            $table->string('kelas');
            $table->string('tahun_pelajaran');
            $table->text('kompetensi_dasar')->nullable();
            $table->text('kompetensi_inti')->nullable();
            $table->text('tujuan_pembelajaran')->nullable();
            $table->text('materi_pembelajaran')->nullable();
            $table->text('asesmen_pembelajaran')->nullable();
            $table->text('metode_pembelajaran')->nullable();
            $table->text('media_pembelajaran')->nullable();
            $table->text('sumber_belajar')->nullable();
            $table->text('lampiran_belajar')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rpps');
    }
};
