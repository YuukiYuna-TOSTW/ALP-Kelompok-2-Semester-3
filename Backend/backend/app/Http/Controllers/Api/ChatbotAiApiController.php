<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ChatbotAi;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ChatbotAiApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(ChatbotAi::latest()->paginate(15));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->all();
        $model = ChatbotAi::create($data);
        return response()->json(['message' => 'Created', 'data' => $model], 201);
    }

    public function show(ChatbotAi $chatbotAi): JsonResponse
    {
        return response()->json($chatbotAi);
    }

    public function update(Request $request, ChatbotAi $chatbotAi): JsonResponse
    {
        $chatbotAi->update($request->all());
        return response()->json(['message' => 'Updated', 'data' => $chatbotAi]);
    }

    public function destroy(ChatbotAi $chatbotAi): JsonResponse
    {
        $chatbotAi->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
