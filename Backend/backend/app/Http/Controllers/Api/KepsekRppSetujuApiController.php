<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use Illuminate\Http\Request;

class KepsekRppSetujuApiController extends Controller
{
    // PUT /api/rpps/{rppId}/setujui
    public function approve($rppId)
    {
        $rpp = Rpp::find($rppId);
        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => [],
            ], 404);
        }

        $rpp->Status = Rpp::STATUS_DISETUJUI; // ✅ menggunakan konstanta dari model
        $rpp->save();

        return response()->json([
            'success' => true,
            'message' => 'Status RPP disetujui',
            'data' => [
                'rpp_id' => $rpp->RPP_ID,
                'Status' => $rpp->Status,
            ],
        ], 200);
    }

    // PUT /api/rpps/{rppId}/revisi
    public function requestRevision($rppId)
    {
        $rpp = Rpp::find($rppId);
        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => [],
            ], 404);
        }

        $rpp->Status = Rpp::STATUS_MINTA_REVISI; // ✅ menggunakan konstanta
        $rpp->save();

        return response()->json([
            'success' => true,
            'message' => 'RPP dikembalikan untuk revisi',
            'data' => [
                'rpp_id' => $rpp->RPP_ID,
                'Status' => $rpp->Status,
            ],
        ], 200);
    }
}