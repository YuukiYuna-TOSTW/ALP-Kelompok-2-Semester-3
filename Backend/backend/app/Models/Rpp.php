<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rpp extends Model
{
    use HasFactory;

    protected $primaryKey = 'RPP_ID';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'Nama_Mata_Pelajaran',
        'Kelas',
        'Tahun_Pelajaran',
        'Kompetensi_Dasar',
        'Kompetensi_Inti',
        'Tujuan_Pembelajaran',
        'Materi_Pembelajaran',
        'Asesmen_Pembelajaran',
        'Metode_Pembelajaran',
        'Media_Pembelajaran',
        'Sumber_Belajar',
        'Lampiran_Belajar',
    ];

    /**
     * Get the chatbot suggestions for this RPP.
     */
    public function chatbotSuggestions()
    {
        return $this->hasMany(ChatbotAi::class, 'RPP_ID', 'RPP_ID');
    }
}
