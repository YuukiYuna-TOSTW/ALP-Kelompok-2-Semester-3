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
            $table->id('RPP_ID');
            $table->string('Nama_Mata_Pelajaran');
            $table->string('Kelas');
            $table->string('Bab_Materi');
            $table->string('Semester');
            $table->text('Kompetensi_Dasar')->nullable();
            $table->text('Kompetensi_Inti')->nullable();
            $table->text('Tujuan_Pembelajaran')->nullable();
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
