<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ScheduleApiController;
use App\Http\Controllers\Api\ChatbotAiApiController;
use App\Http\Controllers\Api\HistoryScheduleApiController;
use App\Http\Controllers\Api\RppApiController;
use App\Http\Controllers\Api\UserApiController;
use App\Http\Controllers\Api\ScheduleUserApiController;
use App\Http\Controllers\Api\OtpController;
use App\Http\Controllers\Api\KepsekRPPApiController;
use App\Http\Controllers\Api\KepsekStatistikSekolahApiController;
use App\Http\Controllers\Api\KepsekKalenderApiController;
use App\Http\Controllers\Api\KepsekRppReviewerApiController;
use App\Http\Controllers\Api\KepsekRppSetujuApiController;
use App\Http\Controllers\Api\RppHistoryApiController;
use App\Http\Controllers\Api\RppReviewDetailApiController;
use App\Http\Controllers\Api\ScheduleReviewApiController;
use App\Http\Controllers\Api\GuruKalenderApiController;
use App\Http\Controllers\Api\AdminRPPApiController;
use App\Http\Controllers\Api\AdminStatistikApiController;
use App\Http\Controllers\Api\AdminKalenderApiController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// OTP Routes
Route::prefix('otp')->group(function () {
    Route::get('/', [OtpController::class, 'index']);
    Route::post('/generate', [OtpController::class, 'generate']);
    Route::post('/verify', [OtpController::class, 'verify']);
    Route::post('/resend', [OtpController::class, 'resend']);
});

// ✅ PINDAHKAN: route khusus schedules SEBELUM apiResource
Route::get('schedules/penyelenggara', [ScheduleApiController::class, 'getPenyelenggara']);

// API resource routes for models (Schedule)
Route::apiResource('schedules', ScheduleApiController::class);

// Pindahkan route create khusus ke atas apiResource agar tidak tertimpa
Route::post('rpps/create', [RppApiController::class, 'store']);

// apiResource akan handle:
// GET    /rpps        -> index
// GET    /rpps/{rpp}  -> show
// PUT    /rpps/{rpp}  -> update
// DELETE /rpps/{rpp}  -> destroy
Route::apiResource('rpps', RppApiController::class);
Route::apiResource('users', UserApiController::class);

// Auth Routes
Route::post('/login', [UserApiController::class, 'login']);
Route::post('/register', [UserApiController::class, 'register']); // endpoint yang dipanggil dari frontend

// ✅ Dashboard endpoints
Route::prefix('dashboard')->group(function () {
    Route::get('/rpps/pending', [KepsekRPPApiController::class, 'pending']);
    Route::get('/kepsekstatistiksekolah', [KepsekStatistikSekolahApiController::class, 'index']);
    Route::get('/kepsekkalender', [KepsekKalenderApiController::class, 'index']);
    Route::get('/gurukalender', [GuruKalenderApiController::class, 'index']);
    
    // Admin endpoints
    Route::get('/admin/rpps', [AdminRPPApiController::class, 'index']);
    Route::get('/admin/statistik', [AdminStatistikApiController::class, 'index']);
    Route::get('/admin/kalender', [AdminKalenderApiController::class, 'index']);
});

// RPP info untuk frontend (tanpa catatan reviewer)
Route::get('rppreview/{rppId}', [\App\Http\Controllers\Api\KepsekRppReviewApiController::class, 'show']);

Route::prefix('rpps/{rppId}')->group(function () {
    Route::get('rppreviewer', [KepsekRppReviewerApiController::class, 'showNotes']);
    Route::put('rppreviewer', [KepsekRppReviewerApiController::class, 'upsertNotes']);
    Route::delete('rppreviewer', [KepsekRppReviewerApiController::class, 'clearNotes']);
    Route::put('rppsetujui', [KepsekRppSetujuApiController::class, 'approve']);
    Route::get('rpphistory', [RppHistoryApiController::class, 'index']);
    Route::get('rppdetail', [RppReviewDetailApiController::class, 'show']);
});

// ✅ TAMBAH: route untuk review schedule
Route::get('schedule-review', [ScheduleReviewApiController::class, 'index']);
Route::get('schedule-review/{id}', [ScheduleReviewApiController::class, 'show']);

