<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\HistorySchedule;
use App\Http\Resources\HistorySchedule as HistoryScheduleResource;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class HistoryScheduleApiController extends Controller
{
    public function index(): JsonResponse
    {
        $items = HistorySchedule::latest()->paginate(15);
        return response()->json(HistoryScheduleResource::collection($items));
    }

    public function show(HistorySchedule $historySchedule): JsonResponse
    {
        return response()->json(new HistoryScheduleResource($historySchedule));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'Schedule_ID' => 'required|integer',
            'Status' => 'nullable|string',
            'Catatan' => 'nullable|string',
            'Waktu_Pelaksanaan' => 'nullable|date',
        ]);

        $model = HistorySchedule::create($data);
        return response()->json(new HistoryScheduleResource($model), 201);
    }

    public function update(Request $request, HistorySchedule $historySchedule): JsonResponse
    {
        $data = $request->validate([
            'Schedule_ID' => 'sometimes|integer',
            'Status' => 'sometimes|nullable|string',
            'Catatan' => 'sometimes|nullable|string',
            'Waktu_Pelaksanaan' => 'sometimes|nullable|date',
        ]);

        $historySchedule->update($data);
        return response()->json(new HistoryScheduleResource($historySchedule));
    }

    public function destroy(HistorySchedule $historySchedule): JsonResponse
    {
        $historySchedule->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
