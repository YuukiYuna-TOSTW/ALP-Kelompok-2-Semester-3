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
        $schedules = Schedule::with('penyelenggara')->latest()->paginate(15);
        return response()->json(ScheduleResource::collection($schedules));
    }

    /**
     * Display the specified schedule.
     */
    public function show($id): JsonResponse
    {
        $schedule = Schedule::with('penyelenggara')->findOrFail($id);
        return response()->json(new ScheduleResource($schedule));
    }

    /**
     * Store a newly created schedule in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'Nama_Schedule' => 'required|string|max:255',
            'Penyelenggara_ID' => 'required|exists:Users,User_ID',
            'Tanggal_Schedule_Dimulai' => 'required|date',
            'Tanggal_Schedule_Berakhir' => 'required|date|after_or_equal:Tanggal_Schedule_Dimulai',
            'Jam_Schedule_Dimulai' => 'required|date_format:H:i',
            'Jam_Schedule_Berakhir' => 'required|date_format:H:i',
            'Deskripsi_Schedule' => 'nullable|string',
            'Dokumen' => 'nullable|string',
        ]);

        $model = Schedule::create($data);
        $model->load('penyelenggara');
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
            'Penyelenggara_Schedule' => 'sometimes|exists:Users,User_ID',
            'Tanggal_Schedule_Dimulai' => 'sometimes|date',
            'Tanggal_Schedule_Berakhir' => 'sometimes|date|after_or_equal:Tanggal_Schedule_Dimulai',
            'Jam_Schedule_Dimulai' => 'sometimes|date_format:H:i',
            'Jam_Schedule_Berakhir' => 'sometimes|date_format:H:i',
            'Deskripsi_Schedule' => 'sometimes|nullable|string',
            'Dokumen' => 'sometimes|nullable|string',
        ]);

        $schedule->update($data);
        $schedule->load('penyelenggara');
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
