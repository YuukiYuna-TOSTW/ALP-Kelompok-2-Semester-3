<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use App\Http\Resources\Rpp as RppResource;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class RppApiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $rpps = Rpp::with('user')->latest()->get();

        return response()->json([
            'success' => true,
            'data' => RppResource::collection($rpps),
            'message' => 'OK',
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'Nama_Mata_Pelajaran' => 'required|string|max:255',
            'Kelas' => 'required|string|max:50',
            'Semester' => 'required|string|max:50',
            'Bab/Materi' => 'required|string|max:255',
            'Kompetensi_Dasar' => 'required|string',
            'Kompetensi_Inti' => 'required|string',
            'Tujuan_Pembelajaran' => 'required|string',
            'Status' => 'required|string',
            'User_ID' => 'required|exists:users,id',
        ]);

        $model = Rpp::create($data);
        return response()->json(new RppResource($model), 201);
    }

    public function show(Rpp $rpp): JsonResponse
    {
        return response()->json(new RppResource($rpp));
    }

    public function update(Request $request, Rpp $rpp): JsonResponse
    {
        $data = $request->validate([
            'Nama_Mata_Pelajaran' => 'nullable|string|max:255',
            'Kelas' => 'nullable|string|max:50',
            'Semester' => 'nullable|string|max:50',
            'Bab/Materi' => 'nullable|string|max:255',
            'Kompetensi_Dasar' => 'nullable|string',
            'Kompetensi_Inti' => 'nullable|string',
            'Tujuan_Pembelajaran' => 'nullable|string',
            'Status' => 'nullable|string',
        ]);

        $rpp->update($data);
        return response()->json(new RppResource($rpp));
    }

    public function destroy(Rpp $rpp): JsonResponse
    {
        $rpp->delete();
        return response()->json(['message' => 'Deleted', 'success' => true]);
    }
}