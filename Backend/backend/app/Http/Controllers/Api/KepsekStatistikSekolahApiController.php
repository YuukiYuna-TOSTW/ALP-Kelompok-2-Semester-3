<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Rpp;
use App\Models\Schedule; // ✅ tambahkan
use Illuminate\Http\JsonResponse;

class KepsekStatistikSekolahApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'total_guru'   => User::where('Role', 'Guru')->count(),
                'rpp_pending'  => Rpp::where('Status', 'Menunggu Review')->count(),
                'total_kelas'  => Schedule::count(),
            ],
            'message' => 'OK',
        ], 200);
    }
}