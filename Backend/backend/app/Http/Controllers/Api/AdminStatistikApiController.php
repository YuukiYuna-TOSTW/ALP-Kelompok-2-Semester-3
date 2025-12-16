<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Rpp;
use App\Models\Schedule;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class AdminStatistikApiController extends Controller
{
    public function index(): JsonResponse
    {
        // Hitung jumlah mata pelajaran unik dari tabel Schedule
        $totalMataPelajaran = Schedule::distinct('Mata_Pelajaran')->count('Mata_Pelajaran');

        return response()->json([
            'success' => true,
            'data' => [
                'total_guru'   => User::where('Role', 'Guru')->count(),
                'total_kelas'  => Schedule::distinct('Kelas')->count('Kelas'),
                'mata_pelajaran' => $totalMataPelajaran,
                'total_jadwal' => Schedule::count(),
                'total_rpp' => Rpp::count(),
            ],
            'message' => 'OK',
        ], 200);
    }
}
