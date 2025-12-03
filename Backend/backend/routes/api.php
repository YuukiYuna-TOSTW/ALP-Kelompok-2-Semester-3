<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ScheduleApiController;
use App\Http\Controllers\Api\ChatbotAiApiController;
use App\Http\Controllers\Api\HistoryScheduleApiController;
use App\Http\Controllers\Api\RppApiController;
use App\Http\Controllers\Api\UserApiController;
use App\Http\Controllers\Api\ScheduleUserApiController;
use App\Http\Controllers\ChatbotController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// API resource routes for models (Schedule)
Route::apiResource('schedules', ScheduleApiController::class);
Route::apiResource('chatbot-ai', ChatbotAiApiController::class);
Route::apiResource('history-schedules', HistoryScheduleApiController::class);
Route::apiResource('rpps', RppApiController::class);
Route::apiResource('users', UserApiController::class);
// schedule_user (pivot) custom routes (composite key)
Route::get('schedule-user', [ScheduleUserApiController::class, 'index']);
Route::post('schedule-user', [ScheduleUserApiController::class, 'store']);
Route::get('schedule-user/{user_id}/{schedule_id}', [ScheduleUserApiController::class, 'show']);
Route::delete('schedule-user/{user_id}/{schedule_id}', [ScheduleUserApiController::class, 'destroy']);

// Chatbot routes untuk Gemini AI
Route::prefix('chatbot')->group(function () {
    Route::get('validate-key', [ChatbotController::class, 'validateApiKey']);
    Route::post('send-message', [ChatbotController::class, 'sendMessage']);
    Route::get('list-models', [ChatbotController::class, 'listModels']);
    Route::get('info', [ChatbotController::class, 'getApiInfo']);
});
