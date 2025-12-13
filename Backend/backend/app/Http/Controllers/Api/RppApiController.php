<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Http\Resources\Rpp as RppResource;

class RppApiController extends Controller
{
    public function index(): JsonResponse
    {
        $rpps = Rpp::latest()->paginate(15);
        return response()->json(RppResource::collection($rpps));
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
            'Nama_Mata_Pelajaran' => 'required|string|max:255',
            'Kelas' => 'required|string|max:50',
            'Semester' => 'required|string|max:50',
            'Bab/Materi' => 'required|string|max:255',
            'Kompetensi_Dasar' => 'required|string',
            'Kompetensi_Inti' => 'required|string',
            'Tujuan_Pembelajaran' => 'required|string',
        ]);

        $rpp->update($data);
        return response()->json(new RppResource($rpp));
    }

    public function destroy(Rpp $rpp): JsonResponse
    {
        $rpp->delete();
        return response()->json(['message' => 'Deleted']);
    }
}