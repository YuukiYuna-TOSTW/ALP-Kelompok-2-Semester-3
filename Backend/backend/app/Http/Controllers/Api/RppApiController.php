<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rpp;
use App\Models\User; // ✅
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Http\Resources\Rpp as RppResource;
use App\Http\Resources\KepsekRPPDashboard; // ✅ perbaiki import

class RppApiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $status = $request->query('status');
        $namaUser = $request->query('nama_user'); // ✅ baru
        $role = $request->query('role');          // ✅ baru

        $query = Rpp::with('user')->latest();

        if ($status) {
            $query->where('Status', $status);
        }

        if ($namaUser) {
            $query->whereHas('user', fn($q) => $q->where('Nama_User', $namaUser));
        }

        if ($role) {
            $query->whereHas('user', fn($q) => $q->where('Role', $role));
        }

        $rpps = $query->get();

        return response()->json([
            'success' => true,
            'data' => RppResource::collection($rpps),
            'message' => 'OK',
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $namaUser = $request->input('Nama_User', 'Kelompok2Guru'); // ✅ default
        $user = User::where('Nama_User', $namaUser)->first();
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User tidak ditemukan'], 404);
        }

        $data = $request->validate([
            'Nama_Mata_Pelajaran' => 'required|string|max:255',
            'Kelas' => 'required|string|max:50',
            'Semester' => 'required|string|max:50',
            'Bab/Materi' => 'required|string|max:255',
            'Kompetensi_Dasar' => 'required|string',
            'Kompetensi_Inti' => 'required|string',
            'Tujuan_Pembelajaran' => 'required|string',
            'Pendahuluan' => 'required|string',
            'Kegiatan_Inti' => 'required|string',
            'Penutup' => 'required|string',
            'Materi_Pembelajaran' => 'required|string',
            'Asesmen_Pembelajaran' => 'required|string',
            'Metode_Pembelajaran' => 'required|string',
            'Media_Pembelajaran' => 'required|string',
            'Sumber_Belajar' => 'required|string',
            'Lampiran' => 'nullable|string',
            'Catatan_Tambahan' => 'nullable|string',
            // Status boleh tidak dikirim; default Menunggu Review
            'Status' => 'sometimes|string|in:Menunggu Review,Minta Revisi,Revisi,Disetujui',
        ]);

        $data['User_ID'] = $user->id;
        $data['Status'] = $data['Status'] ?? 'Menunggu Review'; // ✅ default

        $model = Rpp::create($data);
        return response()->json(new RppResource($model), 201);
    }

    public function show(Rpp $rpp): JsonResponse
    {
        return response()->json(new RppResource($rpp));
    }

    public function update(Request $request, Rpp $rpp): JsonResponse
    {
        $data = $request->validate([
            'Nama_Mata_Pelajaran' => 'required|string|max:255',
            'Kelas' => 'required|string|max:50',
            'Semester' => 'required|string|max:50',
            'Bab/Materi' => 'required|string|max:255',
            'Kompetensi_Dasar' => 'required|string',
            'Kompetensi_Inti' => 'required|string',
            'Tujuan_Pembelajaran' => 'required|string',
            'Pendahuluan' => 'required|string',
            'Kegiatan_Inti' => 'required|string',
            'Penutup' => 'required|string',
            'Materi_Pembelajaran' => 'required|string',
            'Asesmen_Pembelajaran' => 'required|string',
            'Metode_Pembelajaran' => 'required|string',
            'Media_Pembelajaran' => 'required|string',
            'Sumber_Belajar' => 'required|string',
            'Lampiran' => 'nullable|string',
            'Catatan_Tambahan' => 'nullable|string',
            'Status' => 'required|string',
        ]);

        $rpp->update($data);
        return response()->json(new RppResource($rpp));
    }

    public function destroy(Rpp $rpp): JsonResponse
    {
        $rpp->delete();
        return response()->json(['message' => 'Deleted']);
    }
}