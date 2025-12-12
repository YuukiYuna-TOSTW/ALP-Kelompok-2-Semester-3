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
        Schema::create('otp_codes', function (Blueprint $table) {
            $table->id();
            $table->string('Email')->unique();
            $table->string('Kode_OTP', 6);
            $table->timestamp('Expired_At');
            $table->boolean('Is_Verified')->default(false);
            $table->timestamps();

            // Foreign key constraint
            $table->foreign('Email')->references('Email')->on('Users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('otp_codes');
    }
};
