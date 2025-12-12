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
            $table->unsignedBigInteger('Penyelenggara'); 
            $table->date('Tanggal_Schedule_Dimulai');
            $table->date('Tanggal_Schedule_Berakhir');
            $table->time('Jam_Schedule_Dimulai');
            $table->time('Jam_Schedule_Berakhir');
            $table->text('Deskripsi_Schedule')->nullable();
            $table->string('Dokumen')->nullable();
            $table->timestamps();

            // ✅ Foreign key dengan nama kolom baru
            $table->foreign('Penyelenggara')
                ->references('User_ID')
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
