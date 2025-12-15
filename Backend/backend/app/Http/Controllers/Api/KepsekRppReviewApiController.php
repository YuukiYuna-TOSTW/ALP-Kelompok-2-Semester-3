<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use Illuminate\Http\Request;

class KepsekRppReviewApiController extends Controller
{
    /**
     * GET /api/rpp-info/{rppId}
     * Menyajikan data RPP yang dibutuhkan frontend (informasi saja, tanpa catatan reviewer).
     */
    public function show($rppId)
    {
        // Catatan: kolom PK di migration adalah RPP_ID, bukan id
        $rpp = Rpp::where('RPP_ID', $rppId)->first();

        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => [],
            ], 404);
        }

        // Normalisasi key agar cocok dengan kebutuhan frontend
        $data = [
            'rpp_id'      => $rpp->RPP_ID,
            'kd'          => $rpp->Kompetensi_Dasar,
            'ki'          => $rpp->Kompetensi_Inti,
            'tujuan'      => $rpp->Tujuan_Pembelajaran,
            'pendahuluan' => $rpp->Pendahuluan,
            'inti'        => $rpp->Kegiatan_Inti,
            'penutup'     => $rpp->Penutup,
            'catatan'     => $rpp->Catatan_Tambahan,
            'Status'      => $rpp->Status,

            'created_at'  => optional($rpp->created_at)->format('Y-m-d H:i:s'),
            'updated_at'  => optional($rpp->updated_at)->format('Y-m-d H:i:s'),
        ];

        return response()->json([
            'success' => true,
            'message' => 'Informasi RPP berhasil dimuat',
            'data' => $data,
        ], 200);
    }
}