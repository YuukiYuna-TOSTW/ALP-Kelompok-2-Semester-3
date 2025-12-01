<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SaranChatbotSchedule;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SaranChatbotScheduleApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(SaranChatbotSchedule::latest()->paginate(15));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->all();
        $model = SaranChatbotSchedule::create($data);
        return response()->json(['message' => 'Created', 'data' => $model], 201);
    }

    public function show(SaranChatbotSchedule $saranChatbotSchedule): JsonResponse
    {
        return response()->json($saranChatbotSchedule);
    }

    public function update(Request $request, SaranChatbotSchedule $saranChatbotSchedule): JsonResponse
    {
        $saranChatbotSchedule->update($request->all());
        return response()->json(['message' => 'Updated', 'data' => $saranChatbotSchedule]);
    }

    public function destroy(SaranChatbotSchedule $saranChatbotSchedule): JsonResponse
    {
        $saranChatbotSchedule->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
