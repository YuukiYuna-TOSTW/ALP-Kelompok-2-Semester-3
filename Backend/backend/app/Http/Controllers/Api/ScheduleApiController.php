<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\Schedule;
use App\Models\User;
use App\Http\Resources\Schedule as ScheduleResource;
use Illuminate\Support\Facades\Auth;

class ScheduleApiController extends Controller
{
    /**
     * GET /api/schedules
     * Display a listing of schedules.
     */
    public function index(): JsonResponse
    {
        $schedules = Schedule::with('penyelenggara')->latest()->paginate(15);
        return response()->json(ScheduleResource::collection($schedules));
    }

    /**
     * GET /api/schedules/penyelenggara
     * Ambil daftar user untuk pilihan penyelenggara
     */
    public function getPenyelenggara()
    {
        try {
            $users = User::select('id', 'Nama_User', 'Email')
                ->orderBy('Nama_User')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Daftar penyelenggara dimuat',
                'data' => $users->map(fn($u) => [
                    'id' => $u->id,
                    'nama' => $u->Nama_User ?? '-',
                    'email' => $u->Email ?? '-',
                ])->toArray(),
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
     * GET /api/schedules/{id}
     * Display the specified schedule.
     */
    public function show($id): JsonResponse
    {
        $schedule = Schedule::with('penyelenggara')->findOrFail($id);
        return response()->json(new ScheduleResource($schedule));
    }

    /**
     * POST /api/schedules
     * Store a newly created schedule in storage.
     */
    public function store(Request $request): \Illuminate\Http\JsonResponse
    {
        $validated = $request->validate([
            'Nama_Kegiatan' => 'required|string|max:150',
            'Deskripsi' => 'nullable|string',
            'Tanggal_Mulai' => 'required|date_format:Y-m-d',
            'Tanggal_Selesai' => 'required|date_format:Y-m-d|after_or_equal:Tanggal_Mulai',
            'Waktu_Mulai' => 'required|date_format:H:i',
            'Waktu_Selesai' => 'required|date_format:H:i',
            'Tempat' => 'nullable|string|max:100',
            'Penyelenggara_ID' => 'required|integer|exists:users,id',
            'Status' => 'nullable|in:Terjadwal,Berlangsung,Selesai,Dibatalkan',
            'Lampiran' => 'nullable|file|max:5120', // 5MB
        ]);

        // handle file upload
        $lampiranPath = null;
        if ($request->hasFile('Lampiran')) {
            $file = $request->file('Lampiran');
            // simpan ke storage/app/public/lampiran
            $lampiranPath = $file->store('lampiran', 'public'); // returns path like lampiran/xxxx.ext
            $validated['Lampiran'] = $lampiranPath;
        }

        try {
            $schedule = Schedule::create($validated);

            return response()->json([
                'success' => true,
                'message' => 'Kegiatan berhasil disimpan',
                'data' => [
                    'Schedule_ID' => $schedule->Schedule_ID,
                    'Nama_Kegiatan' => $schedule->Nama_Kegiatan,
                    'Tanggal_Mulai' => $schedule->Tanggal_Mulai,
                    'Tanggal_Selesai' => $schedule->Tanggal_Selesai,
                    'Lampiran' => $schedule->Lampiran ?? null,
                    'Lampiran_URL' => $lampiranPath ? asset('storage/'.$lampiranPath) : null,
                ],
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan kegiatan: ' . $e->getMessage(),
                'data' => null,
            ], 500);
        }
    }

    /**
     * PUT /api/schedules/{id}
     * Update the specified schedule in storage.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $schedule = Schedule::findOrFail($id);
        
        $data = $request->validate([
            'Nama_Kegiatan' => 'sometimes|string|max:150',
            'Deskripsi' => 'sometimes|nullable|string',
            'Tanggal_Mulai' => 'sometimes|date_format:Y-m-d',
            'Tanggal_Selesai' => 'sometimes|date_format:Y-m-d|after_or_equal:Tanggal_Mulai',
            'Waktu_Mulai' => 'sometimes|date_format:H:i',
            'Waktu_Selesai' => 'sometimes|date_format:H:i',
            'Tempat' => 'sometimes|nullable|string|max:100',
            'Penyelenggara_ID' => 'sometimes|integer|exists:users,id',
            'Status' => 'sometimes|nullable|in:Terjadwal,Berlangsung,Selesai,Dibatalkan',
        ]);

        $schedule->update($data);
        $schedule->load('penyelenggara');
        
        return response()->json([
            'success' => true,
            'message' => 'Kegiatan berhasil diupdate',
            'data' => new ScheduleResource($schedule),
        ]);
    }

    /**
     * DELETE /api/schedules/{id}
     * Remove the specified schedule from storage.
     */
    public function destroy($id): JsonResponse
    {
        $schedule = Schedule::findOrFail($id);
        $schedule->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Kegiatan berhasil dihapus',
        ]);
    }
}
