<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use App\Models\RppReview;
use Illuminate\Http\Request;

class KepsekRppReviewerApiController extends Controller
{
    // GET: /api/rpps/{rppId}/reviewer-notes
    public function showNotes($rppId)
    {
        $rpp = Rpp::find($rppId);
        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => [],
            ], 404);
        }

        $notes = RppReview::where('RPP_ID', $rppId)->first();

        return response()->json([
            'success' => true,
            'message' => 'Catatan reviewer dimuat',
            'data' => [
                'rpp_id' => (int) $rppId,
                'Status' => $rpp->Status,
                'Catatan_KD' => $notes?->Reviewer_Kompetensi_Dasar,
                'Catatan_KI' => $notes?->Reviewer_Kompetensi_Inti,
                'Catatan_Tujuan' => $notes?->Reviewer_Tujuan_Pembelajaran,
                'Catatan_Pendahuluan' => $notes?->Reviewer_Pendahuluan,
                'Catatan_Inti' => $notes?->Reviewer_Kegiatan_Inti,
                'Catatan_Penutup' => $notes?->Reviewer_Penutup,
                'Catatan_Umum' => $notes?->Reviewer_Catatan_Tambahan,
            ],
        ], 200);
    }

    // PUT: /api/rpps/{rppId}/reviewer-notes
    public function upsertNotes(Request $request, $rppId)
    {
        $rpp = Rpp::find($rppId);
        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => [],
            ], 404);
        }

        $data = $request->validate([
            'Catatan_KD' => 'nullable|string',
            'Catatan_KI' => 'nullable|string',
            'Catatan_Tujuan' => 'nullable|string',
            'Catatan_Pendahuluan' => 'nullable|string',
            'Catatan_Inti' => 'nullable|string',
            'Catatan_Penutup' => 'nullable|string',
            'Catatan_Umum' => 'nullable|string',
        ]);

        $payload = [
            'Reviewer_Kompetensi_Dasar'    => $data['Catatan_KD'] ?? null,
            'Reviewer_Kompetensi_Inti'     => $data['Catatan_KI'] ?? null,
            'Reviewer_Tujuan_Pembelajaran' => $data['Catatan_Tujuan'] ?? null,
            'Reviewer_Pendahuluan'         => $data['Catatan_Pendahuluan'] ?? null,
            'Reviewer_Kegiatan_Inti'       => $data['Catatan_Inti'] ?? null,
            'Reviewer_Penutup'             => $data['Catatan_Penutup'] ?? null,
            'Reviewer_Catatan_Tambahan'    => $data['Catatan_Umum'] ?? null,
        ];

        // Upsert berdasarkan RPP_ID
        $existing = RppReview::where('RPP_ID', $rppId)->first();
        if ($existing) {
            $existing->update($payload + ['updated_at' => now()]);
            $review = $existing->refresh();
            $statusCode = 200;
            $message = 'Catatan reviewer diperbarui';
        } else {
            $review = RppReview::create(['RPP_ID' => (int)$rppId] + $payload + ['created_at' => now(), 'updated_at' => now()]);
            $statusCode = 201;
            $message = 'Catatan reviewer dibuat';
        }

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => [
                'rpp_id' => (int) $rppId,
                'Catatan_KD' => $review->Reviewer_Kompetensi_Dasar,
                'Catatan_KI' => $review->Reviewer_Kompetensi_Inti,
                'Catatan_Tujuan' => $review->Reviewer_Tujuan_Pembelajaran,
                'Catatan_Pendahuluan' => $review->Reviewer_Pendahuluan,
                'Catatan_Inti' => $review->Reviewer_Kegiatan_Inti,
                'Catatan_Penutup' => $review->Reviewer_Penutup,
                'Catatan_Umum' => $review->Reviewer_Catatan_Tambahan,
            ],
        ], $statusCode);
    }

    // DELETE: /api/rpps/{rppId}/reviewer-notes
    public function clearNotes($rppId)
    {
        $rpp = Rpp::find($rppId);
        if (!$rpp) {
            return response()->json([
                'success' => false,
                'message' => 'RPP tidak ditemukan',
                'data' => [],
            ], 404);
        }

        RppReview::where('RPP_ID', $rppId)->update([
            'Reviewer_Kompetensi_Dasar'    => null,
            'Reviewer_Kompetensi_Inti'     => null,
            'Reviewer_Tujuan_Pembelajaran' => null,
            'Reviewer_Pendahuluan'         => null,
            'Reviewer_Kegiatan_Inti'       => null,
            'Reviewer_Penutup'             => null,
            'Reviewer_Catatan_Tambahan'    => null,
            'updated_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Catatan reviewer dikosongkan',
            'data' => ['rpp_id' => (int)$rppId],
        ], 200);
    }
}