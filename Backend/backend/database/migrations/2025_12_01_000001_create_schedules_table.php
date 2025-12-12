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
        Schema::create('Schedules', function (Blueprint $table) {
            $table->id('Schedule_ID');
            $table->string('Nama_Schedule');
            $table->date('Tanggal_Schedule');
            $table->enum('Mata_Pelajaran', ['Sekolah','Matematika', 'Bahasa_Indonesia', 'IPA', 'IPS', 'Bahasa_Inggris', 'Pendidikan_Kewarganegaraan', 'Seni_Budaya', 'Pendidikan_Jasmani', 'TIK', 'Agama', 'PKN']);
            $table->string('Lokasi_Schedule');
            $table->time('Jam_Schedule_Dimulai');
            $table->time('Jam_Schedule_Berakhir');
            $table->string('Penyelenggara_Schedule');
            $table->text('Deskripsi_Schedule')->nullable();
            $table->string('Dokumen')->nullable();
            $table->timestamps();

            $table->foreign('Penyelenggara_Schedule')
                ->references('Nama_User')
                ->on('Users')
                ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Schedules');
    }
};
