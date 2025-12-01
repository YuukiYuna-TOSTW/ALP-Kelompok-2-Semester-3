<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class RppApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Rpp::latest()->paginate(15));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->all();
        $model = Rpp::create($data);
        return response()->json(['message' => 'Created', 'data' => $model], 201);
    }

    public function show(Rpp $rpp): JsonResponse
    {
        return response()->json($rpp);
    }

    public function update(Request $request, Rpp $rpp): JsonResponse
    {
        $rpp->update($request->all());
        return response()->json(['message' => 'Updated', 'data' => $rpp]);
    }

    public function destroy(Rpp $rpp): JsonResponse
    {
        $rpp->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
