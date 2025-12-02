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
            $table->string('Lokasi_Schedule');
            $table->string('Jam_Schedule');
            $table->unsignedBigInteger('User_ID');
            $table->text('Deskripsi_Schedule')->nullable();
            $table->string('Dokumen')->nullable();
            $table->timestamps();

            $table->foreign('User_ID')->references('User_ID')->on('Users')->onDelete('cascade');
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
