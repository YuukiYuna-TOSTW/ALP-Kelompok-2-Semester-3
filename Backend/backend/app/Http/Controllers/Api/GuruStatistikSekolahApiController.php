<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use App\Models\Schedule;
use Illuminate\Http\JsonResponse;
use Carbon\Carbon;

class GuruStatistikSekolahApiController extends Controller
{
    /**
     * GET /api/dashboard/gurustatistiksekolah?nama_user=Kelompok2Guru
     * Kirim data mentah schedule & RPP untuk perhitungan di frontend
     */
    public function show($namaUser = null): JsonResponse
    {
        try {
            $namaUser = $namaUser ?? 'Kelompok2Guru';

            $now = Carbon::now();
            $startOfWeek = $now->copy()->startOfWeek(Carbon::MONDAY)->toDateString();
            $endOfWeek   = $now->copy()->endOfWeek(Carbon::SUNDAY)->toDateString();

            // ==========================================
            // 1. AMBIL SEMUA SCHEDULE MINGGU INI
            // ==========================================
            $schedulesRaw = Schedule::with('penyelenggara:id,Nama_User,Role')
                ->whereHas('penyelenggara', fn($q) => 
                    $q->where('Nama_User', $namaUser)
                      ->where('Role', 'Guru')
                )
                ->whereIn('Status', ['Terjadwal', 'Berlangsung'])
                ->where('Tanggal_Mulai', '<=', $endOfWeek)
                ->where('Tanggal_Selesai', '>=', $startOfWeek)
                ->get();

            $schedules = $schedulesRaw->map(function($s) {
                return [
                    'Schedule_ID' => $s->Schedule_ID,
                    'Nama_Kegiatan' => $s->Nama_Kegiatan,
                    'Tanggal_Mulai' => $s->Tanggal_Mulai ? $s->Tanggal_Mulai->format('Y-m-d') : null,
                    'Tanggal_Selesai' => $s->Tanggal_Selesai ? $s->Tanggal_Selesai->format('Y-m-d') : null,
                    'Waktu_Mulai' => $s->Waktu_Mulai ?? null,
                    'Waktu_Selesai' => $s->Waktu_Selesai ?? null,
                    'Tempat' => $s->Tempat ?? null,
                    'Status' => $s->Status,
                ];
            });

            // ==========================================
            // 2. AMBIL RPP PENDING
            // ==========================================
            $rppPending = Rpp::with('guru:id,Nama_User')
                ->whereHas('guru', fn($q) => $q->where('Nama_User', $namaUser))
                ->whereIn('Status_Review', ['Menunggu Review', 'Minta Revisi', 'Revisi'])
                ->get()
                ->map(fn($r) => [
                    'RPP_ID' => $r->RPP_ID,
                    'Judul' => $r->Judul ?? null,
                    'Status_Review' => $r->Status_Review,
                ]);

            return response()->json([
                'success' => true,
                'data' => [
                    'nama_guru' => $namaUser,
                    'schedules' => $schedules,
                    'rpp_pending' => $rppPending,
                    'tanggal_mulai_minggu' => $startOfWeek,
                    'tanggal_selesai_minggu' => $endOfWeek,
                    'current_date' => $now->toDateString(),
                    'current_time' => $now->format('H:i:s'),
                ],
                'message' => "Data mentah untuk $namaUser",
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }
}