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
        Schema::create('History_Schedules', function (Blueprint $table) {
            $table->id('History_Schedule_ID');
            $table->unsignedBigInteger('Schedule_ID');
            $table->string('Status')->nullable(); // Selesai, Dibatalkan, Berlangsung, etc.
            $table->text('Catatan')->nullable();
            $table->dateTime('Waktu_Pelaksanaan')->nullable();
            $table->timestamps();

            $table->foreign('Schedule_ID')->references('Schedule_ID')->on('Schedules')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('History_Schedules');
    }
};
