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
            'Kegiatan' => $this->Kegiatan ?? $this->title ?? null,
            'Tanggal' => $this->Tanggal ?? $this->date ?? null,
            'Waktu' => $this->Waktu ?? $this->time ?? null,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
