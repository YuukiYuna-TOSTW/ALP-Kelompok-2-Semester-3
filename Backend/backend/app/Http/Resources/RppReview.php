<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RppReview extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            // ID RPP
            'rpp_id'   => $this->RPP_ID,

            // Konten inti RPP
            'kd'       => $this->Kompetensi_Dasar,
            'ki'       => $this->Kompetensi_Inti,
            'tujuan'   => $this->Tujuan_Pembelajaran,
            'pendahuluan' => $this->Pendahuluan,
            'inti'     => $this->Kegiatan_Inti,
            'penutup'  => $this->Penutup,
            'catatan'  => $this->Catatan_Tambahan,

            // Status & user
            'Status'   => $this->Status,
            'Guru_Nama' => $this->user?->Nama_User ?? 'Guru',
            'user' => [
                'id' => $this->user?->id,
                'Nama_User' => $this->user?->Nama_User,
            ],

            // Timestamp opsional
            'created_at' => optional($this->created_at)->format('Y-m-d H:i:s'),
            'updated_at' => optional($this->updated_at)->format('Y-m-d H:i:s'),
        ];
    }
}
