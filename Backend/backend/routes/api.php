<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ScheduleApiController;
use App\Http\Controllers\Api\ChatbotAiApiController;
use App\Http\Controllers\Api\HistoryScheduleApiController;
use App\Http\Controllers\Api\RppApiController;
use App\Http\Controllers\Api\UserApiController;
use App\Http\Controllers\Api\ScheduleUserApiController;
use App\Http\Controllers\Api\OtpApiController;
use App\Http\Controllers\Api\AuthApiController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// OTP Routes
Route::prefix('otp')->group(function () {
    Route::get('/', [OtpApiController::class, 'index']);
    Route::post('/generate', [OtpApiController::class, 'generate']);
    Route::post('/verify', [OtpApiController::class, 'verify']);
    Route::post('/resend', [OtpApiController::class, 'resend']);
    Route::get('/{email}', [OtpApiController::class, 'show']);
    Route::delete('/{email}', [OtpApiController::class, 'destroy']);
});

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
Route::put('schedule-user/{user_id}/{schedule_id}', [ScheduleUserApiController::class, 'update']);
Route::delete('schedule-user/{user_id}/{schedule_id}', [ScheduleUserApiController::class, 'destroy']);

// Auth Routes
Route::post('/login', [UserApiController::class, 'login']);
Route::post('/register', [UserApiController::class, 'register']);
