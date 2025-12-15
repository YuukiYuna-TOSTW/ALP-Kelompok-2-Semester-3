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
            'History_Schedule_ID' => $this->History_Schedule_ID,
            'Schedule_ID' => $this->Schedule_ID,
            'Status' => $this->Status,
            'Catatan' => $this->Catatan,
            'Waktu_Pelaksanaan' => $this->Waktu_Pelaksanaan,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'schedule' => $this->whenLoaded('schedule'),
        ];
    }
}
