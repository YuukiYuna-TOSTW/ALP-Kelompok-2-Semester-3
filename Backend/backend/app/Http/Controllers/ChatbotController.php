<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Exception;

class ChatbotController extends Controller
{
    /**
     * Get Gemini API Key dari konfigurasi
     */
    private function getGeminiApiKey(): string
    {
        return config('services.gemini.api_key');
    }

    /**
     * Validate apakah API Key tersedia
     */
    public function validateApiKey(): JsonResponse
    {
        $apiKey = $this->getGeminiApiKey();
        
        if (empty($apiKey)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gemini API Key tidak ditemukan dalam konfigurasi',
                'data' => null
            ], 400);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'API Key tersedia',
            'data' => [
                'api_key_exists' => true,
                'api_key_length' => strlen($apiKey)
            ]
        ]);
    }

    /**
     * List available Gemini models
     */
    public function listModels(): JsonResponse
    {
        try {
            $apiKey = $this->getGeminiApiKey();
            
            if (empty($apiKey)) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Gemini API Key tidak dikonfigurasi',
                    'data' => null
                ], 500);
            }

            $response = Http::timeout(30)
                ->get(config('services.gemini.list_models_url') . '?key=' . $apiKey);

            if ($response->successful()) {
                return response()->json([
                    'status' => 'success',
                    'message' => 'Daftar model Gemini berhasil diambil',
                    'data' => $response->json()
                ]);
            } else {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Gagal mengambil daftar model',
                    'data' => [
                        'error_code' => $response->status(),
                        'error_message' => $response->json()['error']['message'] ?? 'Unknown error'
                    ]
                ], $response->status());
            }
        } catch (Exception $e) {
            Log::error('List Models Error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan server',
                'data' => ['error' => $e->getMessage()]
            ], 500);
        }
    }

    /**
     * Send message ke Gemini AI
     */
    public function sendMessage(Request $request): JsonResponse
    {
        try {
            // Validasi input
            $request->validate([
                'message' => 'required|string|max:1000',
            ]);

            $apiKey = $this->getGeminiApiKey();
            
            if (empty($apiKey)) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Gemini API Key tidak dikonfigurasi',
                    'data' => null
                ], 500);
            }

            $message = $request->input('message');
            
            // Prepare request untuk Gemini API dengan model yang benar
            $response = Http::timeout(30)
                ->withHeaders([
                    'Content-Type' => 'application/json',
                ])
                ->post(config('services.gemini.base_url') . '?key=' . $apiKey, [
                    'contents' => [
                        [
                            'parts' => [
                                [
                                    'text' => $message
                                ]
                            ]
                        ]
                    ],
                    'generationConfig' => [
                        'temperature' => 0.7,
                        'maxOutputTokens' => 1000,
                    ]
                ]);

            if ($response->successful()) {
                $responseData = $response->json();
                
                // Extract response text dari Gemini
                $aiResponse = $responseData['candidates'][0]['content']['parts'][0]['text'] ?? 'Tidak ada respons dari AI';
                
                return response()->json([
                    'status' => 'success',
                    'message' => 'Pesan berhasil dikirim ke Gemini AI',
                    'data' => [
                        'user_message' => $message,
                        'ai_response' => $aiResponse,
                        'model_used' => config('services.gemini.model'),
                        'timestamp' => now()->toISOString()
                    ]
                ]);
            } else {
                Log::error('Gemini API Error: ' . $response->body());
                
                return response()->json([
                    'status' => 'error',
                    'message' => 'Gagal berkomunikasi dengan Gemini AI',
                    'data' => [
                        'error_code' => $response->status(),
                        'error_message' => $response->json()['error']['message'] ?? 'Unknown error',
                        'full_response' => $response->json()
                    ]
                ], $response->status());
            }
            
        } catch (Exception $e) {
            Log::error('Chatbot Controller Error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan server',
                'data' => [
                    'error' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * Get API configuration info
     */
    public function getApiInfo(): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'message' => 'Informasi konfigurasi API',
            'data' => [
                'gemini_configured' => !empty($this->getGeminiApiKey()),
                'model' => config('services.gemini.model'),
                'base_url' => config('services.gemini.base_url'),
                'endpoints' => [
                    'validate_key' => '/api/chatbot/validate-key',
                    'send_message' => '/api/chatbot/send-message',
                    'list_models' => '/api/chatbot/list-models',
                    'get_info' => '/api/chatbot/info'
                ]
            ]
        ]);
    }
}