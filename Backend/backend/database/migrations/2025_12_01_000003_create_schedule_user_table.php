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
        Schema::create('Schedule_User', function (Blueprint $table) {
            $table->unsignedBigInteger('User_ID');
            $table->unsignedBigInteger('Schedule_ID');
            $table->timestamps();

            $table->primary(['User_ID', 'Schedule_ID']);
            $table->foreign('User_ID')->references('User_ID')->on('Users')->onDelete('cascade');
            $table->foreign('Schedule_ID')->references('Schedule_ID')->on('Schedules')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Schedule_User');
    }
};
