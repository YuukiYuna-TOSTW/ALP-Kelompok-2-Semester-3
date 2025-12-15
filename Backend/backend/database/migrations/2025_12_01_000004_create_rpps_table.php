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
            $table->foreignId('User_ID')->constrained('users', 'id')->onDelete('cascade'); // ✅ foreignId otomatis unsignedBigInteger
            $table->string('Nama_Mata_Pelajaran', 100);
            $table->string('Kelas', 10);
            $table->text('Bab/Materi');
            $table->string('Semester', 20);
            $table->text('Kompetensi_Dasar');
            $table->text('Kompetensi_Inti');
            $table->text('Tujuan_Pembelajaran');
            $table->enum('Status', ['Menunggu Review', 'Minta Revisi', 'Ditolak'])->default('Menunggu Review');
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
