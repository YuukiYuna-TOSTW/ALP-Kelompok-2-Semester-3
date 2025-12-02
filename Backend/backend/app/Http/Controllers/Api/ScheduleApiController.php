<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use App\Http\Resources\Schedule as ScheduleResource;
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
        return response()->json(ScheduleResource::collection($schedules));
    }

    /**
     * Display the specified schedule.
     */
    public function show(Schedule $schedule): JsonResponse
    {
        return response()->json(new ScheduleResource($schedule));
    }

    /**
     * Store a newly created schedule in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'User_ID' => 'required|integer',
            'Kegiatan' => 'required|string',
            'Tanggal' => 'nullable|date',
            'Waktu' => 'nullable|string',
        ]);

        $model = Schedule::create($data);
        return response()->json(new ScheduleResource($model), 201);
    }

    /**
     * Update the specified schedule in storage.
     */
    public function update(Request $request, Schedule $schedule): JsonResponse
    {
        $data = $request->validate([
            'User_ID' => 'sometimes|integer',
            'Kegiatan' => 'sometimes|string',
            'Tanggal' => 'sometimes|nullable|date',
            'Waktu' => 'sometimes|nullable|string',
        ]);

        $schedule->update($data);
        return response()->json(new ScheduleResource($schedule));
    }

    /**
     * Remove the specified schedule from storage.
     */
    public function destroy(Schedule $schedule): JsonResponse
    {
        $schedule->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
