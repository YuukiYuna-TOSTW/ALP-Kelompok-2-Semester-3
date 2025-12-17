<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Http\Resources\User as UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class OtpController extends Controller
{
    // ✅ OTP master untuk testing (sama untuk semua role)
    private const MASTER_OTP = '123456';

    public function generate(Request $request)
    {
        try {
            $email = $request->input('email');

            if (empty($email)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email diperlukan',
                ], 400);
            }

            // ✅ Validasi email format
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Format email tidak valid',
                ], 400);
            }

            // ✅ Cek apakah user dengan email ini ada
            $user = User::where('Email', $email)->first();
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email tidak terdaftar',
                ], 404);
            }

            // ✅ Simpan OTP master ke cache (5 menit)
            // Semua role menggunakan OTP yang sama: 123456
            Cache::put("otp_$email", self::MASTER_OTP, now()->addMinutes(5));

            Log::info("OTP generated for email: $email, OTP: " . self::MASTER_OTP . ", Role: " . $user->Role);

            return response()->json([
                'success' => true,
                'otp_code' => self::MASTER_OTP, // ✅ OTP yang sama untuk semua
                'message' => 'OTP berhasil dikirim ke email Anda',
            ], 200);

        } catch (\Exception $e) {
            Log::error('OTP Generate Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function verify(Request $request)
    {
        try {
            $email = $request->input('email');
            $otp = $request->input('otp');

            if (empty($email) || empty($otp)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email dan OTP diperlukan',
                ], 400);
            }

            // ✅ Ambil OTP dari cache
            $storedOtp = Cache::get("otp_$email");

            if (!$storedOtp) {
                // ✅ Jika cache kosong, gunakan OTP master (fallback untuk testing)
                $storedOtp = self::MASTER_OTP;
            }

            // ✅ Bandingkan OTP (convert ke string)
            if ((string)$otp !== (string)$storedOtp) {
                Log::warning("OTP mismatch for $email. Expected: $storedOtp, Got: $otp");
                return response()->json([
                    'success' => false,
                    'message' => 'OTP tidak valid',
                ], 401);
            }

            // ✅ Hapus OTP dari cache setelah verifikasi
            Cache::forget("otp_$email");

            // ✅ Cari user berdasarkan email
            $user = User::where('Email', $email)->first();
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                ], 404);
            }

            Log::info("OTP verified successfully for email: $email, Role: " . $user->Role);

            return response()->json([
                'success' => true,
                'message' => 'OTP berhasil diverifikasi',
                'user' => new UserResource($user),
            ], 200);

        } catch (\Exception $e) {
            Log::error('OTP Verify Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage(),
            ], 500);
        }
    }
}
