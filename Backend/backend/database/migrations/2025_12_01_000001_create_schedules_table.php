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
        Schema::create('schedules', function (Blueprint $table) {
            $table->id('Schedule_ID');
            $table->string('Nama_Kegiatan', 150);
            $table->text('Deskripsi')->nullable();
            $table->date('Tanggal_Mulai');
            $table->date('Tanggal_Selesai');
            $table->time('Waktu_Mulai');
            $table->time('Waktu_Selesai');
            $table->string('Tempat', 100)->nullable();
            $table->unsignedBigInteger('Penyelenggara_ID'); // ✅ kolom terlebih dahulu\
            $table->string('Lampiran')->nullable();
            $table->enum('Status', ['Terjadwal', 'Berlangsung', 'Selesai', 'Dibatalkan'])->default('Terjadwal');
            $table->timestamps();

            // ✅ Constraint ditambahkan di akhir
            $table->foreign('Penyelenggara_ID')
                ->references('id')
                ->on('users')
                ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('schedules');
    }
};
