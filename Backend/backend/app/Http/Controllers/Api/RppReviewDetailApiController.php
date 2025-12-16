<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;

class RppReviewDetailApiController extends Controller
{
    /**
     * GET /api/rpps/{rppId}/detail
     * Ambil detail lengkap RPP untuk review
     */
    public function show($rppId)
    {
        $rpp = Rpp::with(['user:id,Nama_User'])
            ->where('RPP_ID', $rppId)
            ->first();

        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => null,
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail RPP dimuat',
            'data' => [
                'RPP_ID' => $rpp->RPP_ID,
                'Nama_Guru' => $rpp->user?->Nama_User ?? '-',
                'Nama_Mata_Pelajaran' => $rpp->Nama_Mata_Pelajaran ?? '-',
                'Kelas' => $rpp->Kelas ?? '-',
                'Bab_Materi' => $rpp->{'Bab/Materi'} ?? '-',
                'Semester' => $rpp->Semester ?? '-',
                'Kompetensi_Dasar' => $rpp->Kompetensi_Dasar ?? '-',
                'Kompetensi_Inti' => $rpp->Kompetensi_Inti ?? '-',
                'Tujuan_Pembelajaran' => $rpp->Tujuan_Pembelajaran ?? '-',
                'Pendahuluan' => $rpp->Pendahuluan ?? '-',
                'Kegiatan_Inti' => $rpp->Kegiatan_Inti ?? '-',
                'Penutup' => $rpp->Penutup ?? '-',
                'Asesmen_Pembelajaran' => $rpp->Asesmen_Pembelajaran ?? '-',
                'Metode_Pembelajaran' => $rpp->Metode_Pembelajaran ?? '-',
                'Media_Pembelajaran' => $rpp->Media_Pembelajaran ?? '-',
                'Sumber_Belajar' => $rpp->Sumber_Belajar ?? '-',
                'Lampiran' => $rpp->Lampiran ?? '-',
                'Status' => $rpp->Status ?? '-',
                'created_at' => $rpp->created_at?->format('d-m-Y H:i:s'),
                'updated_at' => $rpp->updated_at?->format('d-m-Y H:i:s'),
            ],
        ], 200);
    }
}