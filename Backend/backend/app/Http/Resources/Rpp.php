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
            'Bab/Materi' => $this->{"Bab/Materi"},
            'Semester' => $this->Semester,
            'Kompetensi_Dasar' => $this->Kompetensi_Dasar,
            'Kompetensi_Inti' => $this->Kompetensi_Inti,
            'Tujuan_Pembelajaran' => $this->Tujuan_Pembelajaran,
        ];
    }
}
