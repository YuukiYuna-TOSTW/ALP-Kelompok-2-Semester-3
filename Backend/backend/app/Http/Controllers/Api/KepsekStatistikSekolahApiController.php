<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Rpp;
use Illuminate\Http\JsonResponse;

class KepsekStatistikSekolahApiController extends Controller
{
    public function index(): JsonResponse
    {
        $totalGuru = User::where('Role', 'Guru')->count();
        $rppPending = Rpp::where('Status', 'Menunggu Review')->count();
        $totalKelas = Rpp::distinct('Kelas')->count('Kelas'); // ✅ hitung kelas unik

        return response()->json([
            'success' => true,
            'data' => [
                'total_guru' => $totalGuru,
                'rpp_pending' => $rppPending,
                'total_kelas' => $totalKelas,
            ],
            'message' => 'OK',
        ]);
    }
}