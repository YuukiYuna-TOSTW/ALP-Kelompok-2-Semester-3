<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ScheduleApiController extends Controller
{
    /**
     * Display a listing of schedules.
     */
    public function index(): JsonResponse
    {
        $schedules = Schedule::latest()->paginate(15);
        return response()->json($schedules);
    }

    /**
     * Store a newly created schedule in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'nama_schedule' => 'required|string|max:255',
            'tanggal_schedule' => 'required|date',
            'lokasi_schedule' => 'nullable|string|max:255',
            'jam_schedule' => 'nullable|string|max:50',
            'user_id' => 'nullable|integer',
            'deskripsi_schedule' => 'nullable|string',
            'dokumen' => 'nullable|string',
        ]);

        $schedule = Schedule::create($data);

        return response()->json(['message' => 'Schedule created', 'data' => $schedule], 201);
    }

    /**
     * Display the specified schedule.
     */
    public function show(Schedule $schedule): JsonResponse
    {
        return response()->json($schedule);
    }

    /**
     * Update the specified schedule in storage.
     */
    public function update(Request $request, Schedule $schedule): JsonResponse
    {
        $data = $request->validate([
            'nama_schedule' => 'sometimes|required|string|max:255',
            'tanggal_schedule' => 'sometimes|required|date',
            'lokasi_schedule' => 'nullable|string|max:255',
            'jam_schedule' => 'nullable|string|max:50',
            'user_id' => 'nullable|integer',
            'deskripsi_schedule' => 'nullable|string',
            'dokumen' => 'nullable|string',
        ]);

        $schedule->update($data);

        return response()->json(['message' => 'Schedule updated', 'data' => $schedule]);
    }

    /**
     * Remove the specified schedule from storage.
     */
    public function destroy(Schedule $schedule): JsonResponse
    {
        $schedule->delete();
        return response()->json(['message' => 'Schedule deleted']);
    }
}
