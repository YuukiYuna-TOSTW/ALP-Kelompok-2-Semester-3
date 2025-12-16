<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;

class RppHistoryApiController extends Controller
{
    public function index()
    {
        $list = Rpp::query()
            ->select([
                'RPP_ID',
                'User_ID',
                'Nama_Mata_Pelajaran',
                'Kelas',
                'Semester',
                'Status',
                'created_at',
                'updated_at',
            ])
            ->with(['user:id,Nama_User'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(function ($rpp) {
                return [
                    'rpp_id'   => $rpp->RPP_ID,
                    'guru'     => $rpp->user?->Nama_User ?? '-',
                    'mapel'    => $rpp->Nama_Mata_Pelajaran ?? '-',
                    'kelas'    => $rpp->Kelas ?? '-',
                    'semester' => $rpp->Semester ?? '-',
                    'tanggal'  => optional($rpp->updated_at ?? $rpp->created_at)->format('d M Y'),
                    'status'   => $rpp->Status ?? '-',
                ];
            });

        return response()->json([
            'success' => true,
            'message' => 'Daftar RPP dimuat',
            'data'    => $list,
        ], 200);
    }
}