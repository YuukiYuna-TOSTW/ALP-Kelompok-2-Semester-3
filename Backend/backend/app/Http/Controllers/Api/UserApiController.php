<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Http\Resources\User as UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

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
        try {
            $data = $request->validate([
                'Nama_User' => 'required|string|max:100|unique:users,Nama_User',
                'Email'     => 'required|email|unique:users,Email',
                'Password'  => 'required|min:6',
                'Role'      => 'nullable|string',
            ]);

            $user = User::create([
                'Nama_User' => $data['Nama_User'],
                'Email'     => $data['Email'],
                'Password'  => Hash::make($data['Password']),
                'Role'      => $data['Role'] ?? 'Guru',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Akun berhasil dibuat',
                'data'    => new UserResource($user),
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => collect($e->errors())->flatten()->first(),
                'errors'  => $e->errors(),
            ], 422);
        }
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

    public function register(Request $request)
    {
        try {
            $data = $request->validate([
                'Nama_User' => 'required|string|max:100|unique:users,Nama_User',
                'Email'     => 'required|email:rfc,dns|unique:users,Email',
                'Password'  => 'required|min:6',
            ]);

            $user = User::create([
                'Nama_User' => $data['Nama_User'],
                'Email'     => $data['Email'],
                'Password'  => bcrypt($data['Password']),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Akun berhasil dibuat',
                'data'    => $user,
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => collect($e->errors())->flatten()->first(),
                'errors'  => $e->errors(),
            ], 422);
        }
    }
    public function login(Request $request)
    {
        $request->validate([
            'Email' => 'required|email',
            'Password' => 'required',
        ]);

        $user = User::where('Email', $request->input('Email'))->first();
        if (!$user || !Hash::check($request->input('Password'), $user->Password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah'
            ], 401);
        }

        // opsional: kembalikan user data
        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'data' => [
                'Nama_User' => $user->Nama_User,
                'Email' => $user->Email,
                'Role' => $user->Role,
            ],
        ], 200);
    }
}
