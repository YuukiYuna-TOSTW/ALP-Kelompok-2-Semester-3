<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class Rpp extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'RPP_ID' => $this->RPP_ID,
            'User_ID' => $this->User_ID, // ✅ opsional
            'Nama_Mata_Pelajaran' => $this->Nama_Mata_Pelajaran,
            'Kelas' => $this->Kelas,
            'Bab/Materi' => $this->{"Bab/Materi"},
            'Semester' => $this->Semester,
            'Kompetensi_Dasar' => $this->Kompetensi_Dasar,
            'Kompetensi_Inti' => $this->Kompetensi_Inti,
            'Tujuan_Pembelajaran' => $this->Tujuan_Pembelajaran,
            'Pendahuluan' => $this->Pendahuluan,
            'Kegiatan_Inti' => $this->Kegiatan_Inti,
            'Penutup' => $this->Penutup,
            'Materi_Pembelajaran' => $this->Materi_Pembelajaran,
            'Asesmen_Pembelajaran' => $this->Asesmen_Pembelajaran,
            'Metode_Pembelajaran' => $this->Metode_Pembelajaran,
            'Media_Pembelajaran' => $this->Media_Pembelajaran,
            'Sumber_Belajar' => $this->Sumber_Belajar,
            'Lampiran' => $this->Lampiran,
            'Catatan_Tambahan' => $this->Catatan_Tambahan,
            'Guru_Nama' => $this->user?->Nama_User ?? 'Guru',
            'Status' => $this->Status,
        ];
    }
}
