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
        Schema::create('history_schedules', function (Blueprint $table) {
            $table->id('history_schedule_id');
            $table->unsignedBigInteger('schedule_id');
            $table->date('tanggal_history_schedule');
            $table->timestamps();

            $table->foreign('schedule_id')->references('schedule_id')->on('schedules')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('history_schedules');
    }
};
