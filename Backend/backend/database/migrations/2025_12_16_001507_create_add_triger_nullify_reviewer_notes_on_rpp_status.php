<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Pastikan tabel ada sebelum membuat trigger
        if (!Schema::hasTable('rpps') || !Schema::hasTable('kepsek_rpp_reviewer')) {
            return;
        }

        DB::unprepared('DROP TRIGGER IF EXISTS trg_rpps_after_update_nullify_notes');

        DB::unprepared("
            CREATE TRIGGER trg_rpps_after_update_nullify_notes
            AFTER UPDATE ON rpps FOR EACH ROW
            BEGIN
                IF NEW.Status IN ('Menunggu Review', 'Menunggu Revisi', 'Revisi', 'Disetujui') THEN
                    UPDATE kepsek_rpp_reviewer
                    SET
                        Reviewer_Kompetensi_Dasar = NULL,
                        Reviewer_Kompetensi_Inti = NULL,
                        Reviewer_Tujuan_Pembelajaran = NULL,
                        Reviewer_Pendahuluan = NULL,
                        Reviewer_Kegiatan_Inti = NULL,
                        Reviewer_Penutup = NULL,
                        Reviewer_Catatan_Tambahan = NULL
                    WHERE RPP_ID = NEW.RPP_ID;
                END IF;
            END
        ");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::unprepared('DROP TRIGGER IF EXISTS trg_rpps_after_update_nullify_notes');
    }
};
