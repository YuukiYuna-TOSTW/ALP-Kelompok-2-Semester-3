<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class User extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            // Informasi Dasar tentang Pengguna
            'Nama_User' => $this->Nama_User,
            'Email' => $this->Email,
            
            // Informasi Tambahan Tentang Role Pengguna
            'Role' => $this->Role ?? null,

            // Informasi Tambahan Tentang Tanggal Pembuatan dan Pembaruan
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
