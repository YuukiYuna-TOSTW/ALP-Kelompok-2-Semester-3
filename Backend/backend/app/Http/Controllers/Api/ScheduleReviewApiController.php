<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ScheduleReviewApiController extends Controller
{
    /**
     * GET /api/schedule-review
     * Ambil semua schedule dengan relasi penyelenggara
     */
    public function index(): JsonResponse
    {
        try {
            // ✅ PERBAIKAN: gunakan 'id' bukan 'User_ID'
            $schedules = Schedule::with('penyelenggara:id,Nama_User,Email')
                ->select(
                    'Schedule_ID',
                    'Nama_Kegiatan',
                    'Tanggal_Mulai',
                    'Tanggal_Selesai',
                    'Waktu_Mulai',
                    'Waktu_Selesai',
                    'Tempat',
                    'Penyelenggara_ID',
                    'Status',
                    'Lampiran'
                )
                ->orderBy('Tanggal_Mulai', 'desc')
                ->get();

            $data = $schedules->map(function ($schedule) {
                return [
                    'Schedule_ID' => $schedule->Schedule_ID,
                    'Nama_Kegiatan' => $schedule->Nama_Kegiatan,
                    'Tanggal_Mulai' => $schedule->Tanggal_Mulai->format('Y-m-d'),
                    'Tanggal_Selesai' => $schedule->Tanggal_Selesai->format('Y-m-d'),
                    'Waktu_Mulai' => $schedule->Waktu_Mulai,
                    'Waktu_Selesai' => $schedule->Waktu_Selesai,
                    'Tempat' => $schedule->Tempat ?? '-',
                    'Penyelenggara' => $schedule->penyelenggara?->Nama_User ?? 'Unknown',
                    'Penyelenggara_Email' => $schedule->penyelenggara?->Email ?? '-',
                    'Status' => $schedule->Status,
                    'Lampiran' => $schedule->Lampiran 
                        ? asset('storage/' . $schedule->Lampiran) 
                        : null,
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Data schedule berhasil dimuat',
                'data' => $data,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'data' => [],
            ], 500);
        }
    }

    /**
     * GET /api/schedule-review/{id}
     * Detail satu schedule
     */
    public function show($id): JsonResponse
    {
        try {
            $schedule = Schedule::with('penyelenggara:id,Nama_User,Email')
                ->where('Schedule_ID', $id)
                ->firstOrFail();

            return response()->json([
                'success' => true,
                'message' => 'Detail schedule',
                'data' => [
                    'Schedule_ID' => $schedule->Schedule_ID,
                    'Nama_Kegiatan' => $schedule->Nama_Kegiatan,
                    'Deskripsi' => $schedule->Deskripsi,
                    'Tanggal_Mulai' => $schedule->Tanggal_Mulai->format('Y-m-d'),
                    'Tanggal_Selesai' => $schedule->Tanggal_Selesai->format('Y-m-d'),
                    'Waktu_Mulai' => $schedule->Waktu_Mulai,
                    'Waktu_Selesai' => $schedule->Waktu_Selesai,
                    'Tempat' => $schedule->Tempat ?? '-',
                    'Penyelenggara' => $schedule->penyelenggara?->Nama_User ?? 'Unknown',
                    'Penyelenggara_Email' => $schedule->penyelenggara?->Email ?? '-',
                    'Status' => $schedule->Status,
                    'Lampiran' => $schedule->Lampiran 
                        ? asset('storage/' . $schedule->Lampiran) 
                        : null,
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Schedule tidak ditemukan',
                'data' => null,
            ], 404);
        }
    }
}