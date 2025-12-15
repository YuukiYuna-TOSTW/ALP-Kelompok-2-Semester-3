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
            'Catatan_Tambahan' => $this->Catatan_Tambahan,
            'Guru_Nama' => $this->user?->Nama_User ?? 'Guru',
            'Status' => $this->Status,
            'user' => [
                'id' => $this->user?->id,
                'Nama_User' => $this->user?->Nama_User,
            ],
        ];
    }
}
