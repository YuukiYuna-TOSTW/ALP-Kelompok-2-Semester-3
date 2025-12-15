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
        Schema::create('schedule_user', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('Schedule_ID'); // ✅ kolom terlebih dahulu
            $table->unsignedBigInteger('User_ID');
            $table->integer('Jumlah_Jam_Kegiatan')->default(0);
            $table->timestamps();

            // ✅ Constraints di akhir
            $table->foreign('Schedule_ID')
                ->references('Schedule_ID')
                ->on('schedules')
                ->onDelete('cascade');

            $table->foreign('User_ID')
                ->references('id')
                ->on('users')
                ->onDelete('cascade');

            $table->unique(['Schedule_ID', 'User_ID']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('schedule_user');
    }
};
