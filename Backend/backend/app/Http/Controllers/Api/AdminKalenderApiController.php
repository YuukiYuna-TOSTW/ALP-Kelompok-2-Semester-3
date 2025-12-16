<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\JsonResponse;

class AdminKalenderApiController extends Controller
{
    public function index(): JsonResponse
    {
        $schedules = Schedule::latest()->get();

        return response()->json([
            'success' => true,
            'data' => $schedules->map(fn($s) => [
                'Nama_Kegiatan' => $s->Nama_Kegiatan,
                'Tanggal_Mulai' => optional($s->Tanggal_Mulai)->format('Y-m-d') ?? $s->Tanggal_Mulai,
                'Status' => $s->Status,
            ])->toArray(),
            'message' => 'OK',
        ], 200);
    }
}
