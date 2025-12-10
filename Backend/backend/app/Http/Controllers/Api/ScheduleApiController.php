<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\Schedule;
use App\Http\Resources\Schedule as ScheduleResource;

class ScheduleApiController extends Controller
{
    /**
     * Display a listing of schedules.
     */
    public function index(): JsonResponse
    {
        $schedules = Schedule::with('creator')->latest()->paginate(15);
        return response()->json(ScheduleResource::collection($schedules));
    }

    /**
     * Display the specified schedule.
     */
    public function show($id): JsonResponse
    {
        $schedule = Schedule::with('creator')->findOrFail($id);
        return response()->json(new ScheduleResource($schedule));
    }

    /**
     * Store a newly created schedule in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'Nama_Schedule' => 'required|string|max:255',
            'Tanggal_Schedule' => 'nullable|date',
            'Lokasi_Schedule' => 'nullable|string|max:255',
            'Jam_Schedule' => 'nullable|string|max:100',
            'User_ID' => 'required|integer|exists:users,User_ID',
            'Deskripsi_Schedule' => 'nullable|string',
            'Dokumen' => 'nullable|string', // jika file upload, tangani secara terpisah
        ]);

        $model = Schedule::create($data);
        return response()->json(new ScheduleResource($model), 201);
    }

    /**
     * Update the specified schedule in storage.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $schedule = Schedule::findOrFail($id);

        $data = $request->validate([
            'Nama_Schedule' => 'sometimes|string|max:255',
            'Tanggal_Schedule' => 'sometimes|nullable|date',
            'Lokasi_Schedule' => 'sometimes|nullable|string|max:255',
            'Jam_Schedule' => 'sometimes|nullable|string|max:100',
            'User_ID' => 'sometimes|integer|exists:users,User_ID',
            'Deskripsi_Schedule' => 'sometimes|nullable|string',
            'Dokumen' => 'sometimes|nullable|string',
        ]);

        $schedule->update($data);
        return response()->json(new ScheduleResource($schedule));
    }

    /**
     * Remove the specified schedule from storage.
     */
    public function destroy($id): JsonResponse
    {
        $schedule = Schedule::findOrFail($id);
        $schedule->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
