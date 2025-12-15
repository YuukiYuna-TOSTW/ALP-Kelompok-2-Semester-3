<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use Illuminate\Http\Request;

class RppApiController extends Controller
{
    // ✅ Get single RPP with all details
    public function show($rppId)
    {
        try {
            $rpp = Rpp::with(['user'])->find($rppId);

            if (!$rpp) {
                return response()->json([
                    'success' => false,
                    'message' => 'RPP tidak ditemukan',
                    'data' => [],
                ], 404);
            }

            // ✅ Format response sesuai kebutuhan frontend
            $data = [
                'id' => $rpp->id,
                'rpp_id' => $rpp->id,
                'Nama_RPP' => $rpp->Nama_RPP ?? '',
                'mapel' => $rpp->Nama_RPP ?? '',
                'kelas' => $rpp->Kelas ?? '-',
                'KD' => $rpp->KD ?? '-',
                'kd' => $rpp->KD ?? '-',
                'KI' => $rpp->KI ?? '-',
                'ki' => $rpp->KI ?? '-',
                'Tujuan' => $rpp->Tujuan ?? '-',
                'tujuan' => $rpp->Tujuan ?? '-',
                'Pendahuluan' => $rpp->Pendahuluan ?? '-',
                'pendahuluan' => $rpp->Pendahuluan ?? '-',
                'Inti' => $rpp->Inti ?? '-',
                'inti' => $rpp->Inti ?? '-',
                'Penutup' => $rpp->Penutup ?? '-',
                'penutup' => $rpp->Penutup ?? '-',
                'Catatan' => $rpp->Catatan ?? '-',
                'catatan' => $rpp->Catatan ?? '-',
                'Status' => $rpp->Status ?? 'Pending',
                'User_ID' => $rpp->User_ID,
                'guru' => $rpp->user ? [
                    'id' => $rpp->user->id,
                    'Nama_User' => $rpp->user->Nama_User ?? '',
                    'Email' => $rpp->user->Email ?? '',
                ] : null,
            ];

            return response()->json([
                'success' => true,
                'message' => 'Data RPP berhasil dimuat',
                'data' => $data,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'data' => [],
            ], 500);
        }
    }

    // ✅ Get all RPP (untuk list)
    public function index()
    {
        try {
            $rpps = Rpp::with(['user'])->get();

            $data = $rpps->map(fn($rpp) => [
                'id' => $rpp->id,
                'rpp_id' => $rpp->id,
                'Nama_RPP' => $rpp->Nama_RPP ?? '',
                'mapel' => $rpp->Nama_RPP ?? '',
                'kelas' => $rpp->Kelas ?? '-',
                'Status' => $rpp->Status ?? 'Pending',
                'guru' => $rpp->user?->Nama_User ?? '-',
            ])->toArray();

            return response()->json([
                'success' => true,
                'message' => 'Data RPP berhasil dimuat',
                'data' => $data,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'data' => [],
            ], 500);
        }
    }
}