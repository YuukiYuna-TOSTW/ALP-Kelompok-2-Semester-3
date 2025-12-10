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
        Schema::create('Chatbot_AI', function (Blueprint $table) {
            $table->id('Chat_ID');
            $table->string('Judul_Chat');
            $table->text('Request_History')->nullable();
            $table->text('Send_History')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Chatbot_AI');
    }
};
