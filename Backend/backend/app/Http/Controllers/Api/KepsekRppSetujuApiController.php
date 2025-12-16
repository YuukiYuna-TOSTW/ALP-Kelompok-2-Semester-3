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

        $rpp->Status = Rpp::STATUS_DISETUJUI;
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
}