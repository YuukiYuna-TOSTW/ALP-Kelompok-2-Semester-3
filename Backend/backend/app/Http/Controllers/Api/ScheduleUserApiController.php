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
            'user_id' => 'required|exists:users,User_ID',
            'schedule_id' => 'required|exists:schedules,Schedule_ID',
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

    // PUT /api/schedule-user/{user_id}/{schedule_id}
    public function update(Request $request, $user_id, $schedule_id): JsonResponse
    {
        $item = ScheduleUser::where('user_id', $user_id)->where('schedule_id', $schedule_id)->first();
        
        if (!$item) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $data = $request->validate([
            'user_id' => 'sometimes|exists:users,User_ID',
            'schedule_id' => 'sometimes|exists:schedules,Schedule_ID',
        ]);

        // Check duplicate jika mengubah relasi
        if (isset($data['user_id']) || isset($data['schedule_id'])) {
            $newUserId = $data['user_id'] ?? $user_id;
            $newScheduleId = $data['schedule_id'] ?? $schedule_id;

            $exists = ScheduleUser::where('user_id', $newUserId)
                ->where('schedule_id', $newScheduleId)
                ->where(function($query) use ($user_id, $schedule_id) {
                    $query->where('user_id', '!=', $user_id)
                        ->orWhere('schedule_id', '!=', $schedule_id);
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
        $deleted = ScheduleUser::where('user_id', $user_id)->where('schedule_id', $schedule_id)->delete();
        if (! $deleted) {
            return response()->json(['message' => 'Not found'], 404);
        }
        return response()->json(['message' => 'Deleted']);
    }
}