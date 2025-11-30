<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class HistorySchedule extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            // Informasi Dasar Tentang History Schedule
            'Nama_Schedule' => $this->Nama_Schedule,
            'Tanggal_History_Schedule' => $this->Tanggal_History_Schedule,
        ];
    }
}
