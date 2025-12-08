<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class Schedule extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'Nama_Schedule' => $this->Nama_Schedule,
            'Tanggal_Schedule' => $this->Tanggal_Schedule,
            'Lokasi_Schedule' => $this->Lokasi_Schedule,
            'Jam_Schedule' => $this->Jam_Schedule,
            'Deskripsi_Schedule' => $this->Deskripsi_Schedule,
            'Dokumen' => $this->Dokumen,
        ];
    }
}
