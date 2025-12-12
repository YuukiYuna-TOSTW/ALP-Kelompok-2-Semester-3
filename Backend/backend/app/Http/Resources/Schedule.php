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
            'Nama_Schedule' => $this->Nama_Schedule,
            'Penyelenggara_ID' => $this->Penyelenggara_ID,
            'Penyelenggara_Nama' => $this->whenLoaded('penyelenggara', fn () => $this->penyelenggara->Nama_User), // Nama_User dari Users
            'Tanggal_Schedule_Dimulai' => $this->Tanggal_Schedule_Dimulai,
            'Tanggal_Schedule_Berakhir' => $this->Tanggal_Schedule_Berakhir,
            'Jam_Schedule_Dimulai' => $this->Jam_Schedule_Dimulai,
            'Jam_Schedule_Berakhir' => $this->Jam_Schedule_Berakhir,
            'Deskripsi_Schedule' => $this->Deskripsi_Schedule,
            'Dokumen' => $this->Dokumen,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
