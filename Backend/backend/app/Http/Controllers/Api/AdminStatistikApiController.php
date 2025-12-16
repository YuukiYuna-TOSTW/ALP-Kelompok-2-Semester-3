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
        // Hitung kelas unik dari tabel RPP
        $totalKelas = Rpp::distinct('Kelas')->count('Kelas');
        
        // Hitung mata pelajaran unik dari tabel RPP
        $totalMataPelajaran = Rpp::distinct('Nama_Mata_Pelajaran')->count('Nama_Mata_Pelajaran');

        return response()->json([
            'success' => true,
            'data' => [
                'total_guru'     => User::where('Role', 'Guru')->count(),
                'total_kelas'    => $totalKelas,
                'mata_pelajaran' => $totalMataPelajaran,
                'total_jadwal'   => Schedule::count(), // Total kegiatan sekolah
                'total_rpp'      => Rpp::count(),
            ],
            'message' => 'OK',
        ], 200);
    }
}
