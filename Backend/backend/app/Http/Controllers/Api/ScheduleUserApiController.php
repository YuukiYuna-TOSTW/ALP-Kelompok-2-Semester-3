<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ScheduleUser;
use Illuminate\Http\Request;

class ScheduleUserApiController extends Controller
{
    // Get all schedule-user relations
    public function index()
    {
        $scheduleUsers = ScheduleUser::with(['user', 'schedule'])->get();
        return response()->json([
            'success' => true,
            'data' => $scheduleUsers
        ]);
    }

    // Create new relation
    public function store(Request $request)
    {
        $validated = $request->validate([
            'User_ID' => 'required|exists:users,User_ID',
            'Schedule_ID' => 'required|exists:schedules,Schedule_ID'
        ]);

        // Check if relation already exists
        $exists = ScheduleUser::where('User_ID', $validated['User_ID'])
            ->where('Schedule_ID', $validated['Schedule_ID'])
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Relation already exists'
            ], 409);
        }

        $scheduleUser = ScheduleUser::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'User assigned to schedule successfully',
            'data' => $scheduleUser
        ], 201);
    }

    // Get specific relation by composite key
    public function show($userId, $scheduleId)
    {
        $scheduleUser = ScheduleUser::where('User_ID', $userId)
            ->where('Schedule_ID', $scheduleId)
            ->with(['user', 'schedule'])
            ->first();

        if (!$scheduleUser) {
            return response()->json([
                'success' => false,
                'message' => 'Relation not found'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $scheduleUser
        ]);
    }

    // Update relation (change schedule for user)
    public function update(Request $request, $userId, $scheduleId)
    {
        $scheduleUser = ScheduleUser::where('User_ID', $userId)
            ->where('Schedule_ID', $scheduleId)
            ->first();

        if (!$scheduleUser) {
            return response()->json([
                'success' => false,
                'message' => 'Relation not found'
            ], 404);
        }

        // Delete old relation
        $scheduleUser->delete();

        // Create new relation if new IDs provided
        $validated = $request->validate([
            'User_ID' => 'required|exists:users,User_ID',
            'Schedule_ID' => 'required|exists:schedules,Schedule_ID'
        ]);

        $newRelation = ScheduleUser::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Relation updated successfully',
            'data' => $newRelation
        ]);
    }

    // Delete relation
    public function destroy($userId, $scheduleId)
    {
        $scheduleUser = ScheduleUser::where('User_ID', $userId)
            ->where('Schedule_ID', $scheduleId)
            ->first();

        if (!$scheduleUser) {
            return response()->json([
                'success' => false,
                'message' => 'Relation not found'
            ], 404);
        }

        $scheduleUser->delete();

        return response()->json([
            'success' => true,
            'message' => 'User removed from schedule successfully'
        ]);
    }
}