<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class Schedule extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray($request): array
    {
        return [
            'Schedule_ID' => $this->Schedule_ID,
            'Nama_Kegiatan' => $this->Nama_Kegiatan,
            'Deskripsi' => $this->Deskripsi,
            'Tanggal_Mulai' => $this->Tanggal_Mulai,
            'Tanggal_Selesai' => $this->Tanggal_Selesai,
            'Waktu_Mulai' => $this->Waktu_Mulai,
            'Waktu_Selesai' => $this->Waktu_Selesai,
            'Tempat' => $this->Tempat,
            'Penyelenggara_ID' => $this->Penyelenggara_ID,
            'Penyelenggara_Nama' => $this->whenLoaded('penyelenggara', fn () => $this->penyelenggara->Nama_User),
            'Lampiran' => $this->Lampiran,
            'Status' => $this->Status,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
