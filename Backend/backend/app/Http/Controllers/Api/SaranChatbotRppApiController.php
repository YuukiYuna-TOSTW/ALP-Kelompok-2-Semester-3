<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SaranChatbotRpp;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SaranChatbotRppApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(SaranChatbotRpp::latest()->paginate(15));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->all();
        $model = SaranChatbotRpp::create($data);
        return response()->json(['message' => 'Created', 'data' => $model], 201);
    }

    public function show(SaranChatbotRpp $saranChatbotRpp): JsonResponse
    {
        return response()->json($saranChatbotRpp);
    }

    public function update(Request $request, SaranChatbotRpp $saranChatbotRpp): JsonResponse
    {
        $saranChatbotRpp->update($request->all());
        return response()->json(['message' => 'Updated', 'data' => $saranChatbotRpp]);
    }

    public function destroy(SaranChatbotRpp $saranChatbotRpp): JsonResponse
    {
        $saranChatbotRpp->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
