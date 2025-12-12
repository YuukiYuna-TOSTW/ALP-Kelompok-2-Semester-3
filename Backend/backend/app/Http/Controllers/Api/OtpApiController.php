<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\OtpCodeResource;
use App\Models\OtpCode;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Carbon\Carbon;

class OtpApiController extends Controller
{
    /**
     * Display a listing of all OTP codes.
     */
    public function index(): JsonResponse
    {
        $otpCodes = OtpCode::orderBy('created_at', 'desc')->get();
        
        return response()->json([
            'success' => true,
            'message' => 'OTP codes retrieved successfully',
            'data' => OtpCodeResource::collection($otpCodes)
        ], 200);
    }

    /**
     * Generate and send OTP code for a user.
     */
    public function generate(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email|exists:Users,Email',
        ]);

        // Check if user exists
        $user = User::where('Email', $request->email)->first();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User not found'
            ], 404);
        }

        // Generate random 6-digit OTP
        $otpCode = str_pad((string) rand(0, 999999), 6, '0', STR_PAD_LEFT);

        // Delete existing OTP for this email
        OtpCode::where('Email', $request->email)->delete();

        // Create new OTP
        $otp = OtpCode::create([
            'Email' => $request->email,
            'Kode_OTP' => $otpCode,
            'Expired_At' => Carbon::now()->addMinutes(5),
            'Is_Verified' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'OTP generated successfully',
            'data' => new OtpCodeResource($otp)
        ], 201);
    }

    /**
     * Verify OTP code.
     */
    public function verify(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'kode_otp' => 'required|string|size:6',
        ]);

        $otp = OtpCode::where('Email', $request->email)->first();

        if (!$otp) {
            return response()->json([
                'success' => false,
                'message' => 'OTP not found for this email'
            ], 404);
        }

        if ($otp->Is_Verified) {
            return response()->json([
                'success' => false,
                'message' => 'OTP already verified'
            ], 400);
        }

        if ($otp->isExpired()) {
            return response()->json([
                'success' => false,
                'message' => 'OTP has expired'
            ], 400);
        }

        if ($otp->Kode_OTP !== $request->kode_otp) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid OTP code'
            ], 400);
        }

        // Mark OTP as verified
        $otp->update(['Is_Verified' => true]);

        return response()->json([
            'success' => true,
            'message' => 'OTP verified successfully',
            'data' => new OtpCodeResource($otp)
        ], 200);
    }

    /**
     * Resend OTP code.
     */
    public function resend(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email|exists:Users,Email',
        ]);

        // Generate new OTP
        return $this->generate($request);
    }

    /**
     * Display the specified OTP code.
     */
    public function show(string $email): JsonResponse
    {
        $otp = OtpCode::where('Email', $email)->first();

        if (!$otp) {
            return response()->json([
                'success' => false,
                'message' => 'OTP not found'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'OTP retrieved successfully',
            'data' => new OtpCodeResource($otp)
        ], 200);
    }

    /**
     * Remove the specified OTP code.
     */
    public function destroy(string $email): JsonResponse
    {
        $otp = OtpCode::where('Email', $email)->first();

        if (!$otp) {
            return response()->json([
                'success' => false,
                'message' => 'OTP not found'
            ], 404);
        }

        $otp->delete();

        return response()->json([
            'success' => true,
            'message' => 'OTP deleted successfully'
        ], 200);
    }
}
