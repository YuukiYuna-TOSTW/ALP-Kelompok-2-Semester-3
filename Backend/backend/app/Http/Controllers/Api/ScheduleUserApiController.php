<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ScheduleUser;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

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
            'User_ID' => 'required|exists:users,User_ID',
            'Schedule_ID' => 'required|exists:schedules,Schedule_ID',
        ]);

        $exists = ScheduleUser::where('User_ID', $data['User_ID'])
            ->where('Schedule_ID', $data['Schedule_ID'])
            ->exists();

        if ($exists) {
            return response()->json(['message' => 'Relation already exists'], 409);
        }

        $item = ScheduleUser::create($data);
        return response()->json(['message' => 'Created', 'data' => $item], 201);
    }

    // GET /api/schedule-user/{user_id}/{schedule_id}
    public function show($user_id, $schedule_id): JsonResponse
    {
        $item = ScheduleUser::where('User_ID', $user_id)
            ->where('Schedule_ID', $schedule_id)
            ->first();

        if (!$item) {
            return response()->json(['message' => 'Not found'], 404);
        }
        return response()->json($item);
    }

    // PUT /api/schedule-user/{user_id}/{schedule_id}
    public function update(Request $request, $user_id, $schedule_id): JsonResponse
    {
        $item = ScheduleUser::where('User_ID', $user_id)
            ->where('Schedule_ID', $schedule_id)
            ->first();

        if (!$item) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $data = $request->validate([
            'User_ID' => 'sometimes|exists:users,User_ID',
            'Schedule_ID' => 'sometimes|exists:schedules,Schedule_ID',
        ]);

        if (isset($data['User_ID']) || isset($data['Schedule_ID'])) {
            $newUserId = $data['User_ID'] ?? $user_id;
            $newScheduleId = $data['Schedule_ID'] ?? $schedule_id;

            $exists = ScheduleUser::where('User_ID', $newUserId)
                ->where('Schedule_ID', $newScheduleId)
                ->where(function ($query) use ($user_id, $schedule_id) {
                    $query->where('User_ID', '!=', $user_id)
                          ->orWhere('Schedule_ID', '!=', $schedule_id);
                })
                ->exists();

            if ($exists) {
                return response()->json(['message' => 'Relation already exists'], 409);
            }
        }

        $item->update($data);
        return response()->json(['message' => 'Updated', 'data' => $item]);
    }

    // DELETE /api/schedule-user/{user_id}/{schedule_id}
    public function destroy($user_id, $schedule_id): JsonResponse
    {
        $deleted = ScheduleUser::where('User_ID', $user_id)
            ->where('Schedule_ID', $schedule_id)
            ->delete();

        if (!$deleted) {
            return response()->json(['message' => 'Not found'], 404);
        }
        return response()->json(['message' => 'Deleted']);
    }
}