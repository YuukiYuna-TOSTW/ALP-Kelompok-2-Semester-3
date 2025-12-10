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
            'Status' => $this->Status ?? null,
            'Catatan' => $this->Catatan ?? null,
            'Waktu_Pelaksanaan' => $this->Waktu_Pelaksanaan ?? $this->performed_at ?? null,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
