<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GuruKalenderApiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $namaUser = $request->query('nama_user'); // opsional, misal Kelompok2Guru

        $schedules = Schedule::with('penyelenggara:id,Nama_User,Role')
            ->when($namaUser, fn($q) => $q->whereHas('penyelenggara', fn($u) => $u->where('Nama_User', $namaUser)))
            ->whereHas('penyelenggara', fn($u) => $u->where('Role', 'Guru'))
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $schedules->map(fn($s) => [
                'Nama_Kegiatan' => $s->Nama_Kegiatan,
                'Tanggal_Mulai' => optional($s->Tanggal_Mulai)->format('Y-m-d'),
                'Status'        => $s->Status,
            ])->toArray(),
            'message' => 'OK',
        ], 200);
    }
}