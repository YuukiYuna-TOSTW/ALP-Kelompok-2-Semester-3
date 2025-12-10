<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRppsTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rpps', function (Blueprint $table) {
            $table->bigIncrements('RPP_ID');
            $table->string('Nama_Mata_Pelajaran');
            $table->string('Kelas');
            $table->string('Tahun_Pelajaran');
            $table->text('Kompetensi_Dasar')->nullable();
            $table->text('Kompetensi_Inti')->nullable();
            $table->text('Tujuan_Pembelajaran')->nullable();
            $table->text('Materi_Pembelajaran')->nullable();
            $table->text('Asesmen_Pembelajaran')->nullable();
            $table->text('Metode_Pembelajaran')->nullable();
            $table->text('Media_Pembelajaran')->nullable();
            $table->text('Sumber_Belajar')->nullable();
            $table->text('Lampiran_Belajar')->nullable();
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
}
