<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Http\Resources\User as UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\JsonResponse;

class UserApiController extends Controller
{
    public function index(): JsonResponse
    {
        $users = User::latest()->paginate(15);
        return response()->json(UserResource::collection($users));
    }

    public function show(User $user): JsonResponse
    {
        return response()->json(new UserResource($user));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'Nama_User' => 'required|string|max:255',
            'Email' => 'required|email|unique:users,Email',
            'Password' => 'required|string|min:6',
            'Role' => 'nullable|string',
        ]);

        $data['Password'] = Hash::make($data['Password']);
        $user = User::create($data);

        return response()->json(new UserResource($user), 201);
    }

    public function update(Request $request, User $user): JsonResponse
    {
        $data = $request->validate([
            'Nama_User' => 'sometimes|string|max:255',
            'Email' => 'sometimes|email|unique:users,Email,' . $user->getKey() . ',User_ID',
            'Password' => 'sometimes|nullable|string|min:6',
            'Role' => 'sometimes|nullable|string',
        ]);

        if (!empty($data['Password'])) {
            $data['Password'] = Hash::make($data['Password']);
        } else {
            unset($data['Password']);
        }

        $user->update($data);
        return response()->json(new UserResource($user));
    }

    public function destroy(User $user): JsonResponse
    {
        $user->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
