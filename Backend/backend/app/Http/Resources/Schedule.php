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
            'Tanggal_Schedule' => optional($this->Tanggal_Schedule)->toDateString(),
            'Lokasi_Schedule' => $this->Lokasi_Schedule,
            'Jam_Schedule' => $this->Jam_Schedule,
            'User_ID' => $this->User_ID,
            'Deskripsi_Schedule' => $this->Deskripsi_Schedule,
            'Dokumen' => $this->Dokumen,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
