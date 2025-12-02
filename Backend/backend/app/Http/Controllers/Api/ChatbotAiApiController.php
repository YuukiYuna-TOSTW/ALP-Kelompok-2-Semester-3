<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ChatbotAi;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Http\Resources\ChatbotAI as ChatbotAIResource;

class ChatbotAiApiController extends Controller
{
    public function index(): JsonResponse
    {
        $items = ChatbotAi::latest()->paginate(15);
        return response()->json(ChatbotAIResource::collection($items));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'Judul_Chat' => 'required|string',
            // validasi lain...
        ]);
        $model = ChatbotAi::create($data);
        return response()->json(new ChatbotAIResource($model), 201);
    }

    public function show(ChatbotAi $chatbotAi): JsonResponse
    {
        return response()->json(new ChatbotAIResource($chatbotAi));
    }

    public function update(Request $request, ChatbotAi $chatbotAi): JsonResponse
    {
        $chatbotAi->update($request->all());
        return response()->json(new ChatbotAIResource($chatbotAi));
    }

    public function destroy(ChatbotAi $chatbotAi): JsonResponse
    {
        $chatbotAi->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
