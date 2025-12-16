<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class KepsekRPPDashboard extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'RPP_ID' => $this->RPP_ID,
            'Nama_Mata_Pelajaran' => $this->Nama_Mata_Pelajaran,
            'Kelas' => $this->Kelas,
            'Guru_Nama' => $this->user?->Nama_User ?? 'Guru',
            'Semester' => $this->Semester,
            'Bab_Materi' => $this->{'Bab/Materi'} ?? '',
            'Status' => $this->Status,
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}