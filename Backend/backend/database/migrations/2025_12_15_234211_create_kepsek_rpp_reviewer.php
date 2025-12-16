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
        Schema::create('kepsek_rpp_reviewer', function (Blueprint $table) {
            $table->id('Reviewer_ID');
            $table->unsignedBigInteger('RPP_ID');
            $table->text('Reviewer_Kompetensi_Dasar')->nullable();
            $table->text('Reviewer_Kompetensi_Inti')->nullable();
            $table->text('Reviewer_Tujuan_Pembelajaran')->nullable();
            $table->text('Reviewer_Pendahuluan')->nullable();
            $table->text('Reviewer_Kegiatan_Inti')->nullable();
            $table->text('Reviewer_Penutup')->nullable();
            $table->text('Reviewer_Catatan_Tambahan')->nullable();
            $table->timestamps();

            $table->foreign('RPP_ID')
                  ->references('RPP_ID')
                  ->on('rpps')
                  ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('kepsek_rpp_reviewer');
    }
};
