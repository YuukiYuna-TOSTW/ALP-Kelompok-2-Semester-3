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
        Schema::create('saran_chatbot_rpps', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('rpp_id');
            $table->timestamps();

            $table->foreign('rpp_id')->references('rpp_id')->on('rpps')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('saran_chatbot_rpps');
    }
};
