<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ScheduleUser;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class ScheduleUserApiController extends Controller
{
    // GET /api/schedule-user
    public function index(): JsonResponse
    {
        $items = ScheduleUser::query()->paginate(20);
        return response()->json($items);
    }

    // POST /api/schedule-user
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'schedule_id' => 'required|exists:schedules,schedule_id',
        ]);

        // prevent duplicate
        $exists = ScheduleUser::where('user_id', $data['user_id'])
            ->where('schedule_id', $data['schedule_id'])->exists();

        if ($exists) {
            return response()->json(['message' => 'Relation already exists'], 409);
        }

        $item = ScheduleUser::create($data);
        return response()->json(['message' => 'Created', 'data' => $item], 201);
    }

    // GET /api/schedule-user/{user_id}/{schedule_id}
    public function show($user_id, $schedule_id): JsonResponse
    {
        $item = ScheduleUser::where('user_id', $user_id)->where('schedule_id', $schedule_id)->first();
        if (! $item) {
            return response()->json(['message' => 'Not found'], 404);
        }
        return response()->json($item);
    }

    // DELETE /api/schedule-user/{user_id}/{schedule_id}
    public function destroy($user_id, $schedule_id): JsonResponse
    {
        $deleted = ScheduleUser::where('user_id', $user_id)->where('schedule_id', $schedule_id)->delete();
        if (! $deleted) {
            return response()->json(['message' => 'Not found'], 404);
        }
        return response()->json(['message' => 'Deleted']);
    }
}
