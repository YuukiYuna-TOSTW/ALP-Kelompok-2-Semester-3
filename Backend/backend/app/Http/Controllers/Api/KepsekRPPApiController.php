<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use App\Http\Resources\KepsekRPPDashboard;
use Illuminate\Http\JsonResponse;

class KepsekRPPApiController extends Controller
{
    public function pending(): JsonResponse
    {
        $rpps = Rpp::with('user')
            ->where('Status', 'Menunggu Review')
            ->latest()
            ->get();

        // Flatten resource collection menjadi array biasa (bukan {"data": [...]})
        $data = KepsekRPPDashboard::collection($rpps)->toArray(request());

        return response()->json([
            'success' => true,
            'data' => $data, // <-- array of items (bukan {"data":[...]} )
            'message' => 'OK',
        ], 200);
    }
}