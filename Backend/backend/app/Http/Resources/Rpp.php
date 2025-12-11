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
            'Nama_Mata_Pelajaran' => $this->Nama_Mata_Pelajaran,
            'Kelas' => $this->Kelas,
            'Tahun_Pelajaran' => $this->Tahun_Pelajaran,
            'Kompetensi_Dasar' => $this->Kompetensi_Dasar,
            'Kompetensi_Inti' => $this->Kompetensi_Inti,
            'Tujuan_Pembelajaran' => $this->Tujuan_Pembelajaran,
            'Materi_Pembelajaran' => $this->Materi_Pembelajaran,
            'Asesmen_Pembelajaran' => $this->Asesmen_Pembelajaran,
            'Metode_Pembelajaran' => $this->Metode_Pembelajaran,
            'Media_Pembelajaran' => $this->Media_Pembelajaran,
            'Sumber_Belajar' => $this->Sumber_Belajar,
            'Lampiran_Belajar' => $this->Lampiran_Belajar,
        ];
    }
}
