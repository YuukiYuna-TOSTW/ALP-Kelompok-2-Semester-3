<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ChatbotAI extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return[
        'Judul_Chat' => $this->Judul_Chat,
        'Request_History' => $this->Request_History,
        'Send_History' => $this->Send_History,
        ];
    }
}
