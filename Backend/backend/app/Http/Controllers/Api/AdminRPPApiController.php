<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use App\Http\Resources\KepsekRPPDashboard;
use Illuminate\Http\JsonResponse;

class AdminRPPApiController extends Controller
{
    public function index(): JsonResponse
    {
        $rpps = Rpp::with('user')
            ->latest()
            ->get();

        // Flatten resource collection menjadi array biasa
        $data = KepsekRPPDashboard::collection($rpps)->toArray(request());

        return response()->json([
            'success' => true,
            'data' => $data,
            'message' => 'OK',
        ], 200);
    }
}
