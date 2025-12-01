<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\HistorySchedule;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class HistoryScheduleApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(HistorySchedule::latest()->paginate(15));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->all();
        $model = HistorySchedule::create($data);
        return response()->json(['message' => 'Created', 'data' => $model], 201);
    }

    public function show(HistorySchedule $historySchedule): JsonResponse
    {
        return response()->json($historySchedule);
    }

    public function update(Request $request, HistorySchedule $historySchedule): JsonResponse
    {
        $historySchedule->update($request->all());
        return response()->json(['message' => 'Updated', 'data' => $historySchedule]);
    }

    public function destroy(HistorySchedule $historySchedule): JsonResponse
    {
        $historySchedule->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
