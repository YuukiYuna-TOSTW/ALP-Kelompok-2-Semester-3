<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rpp extends Model
{
    use HasFactory;

    protected $primaryKey = 'rpp_id';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'nama_mata_pelajaran',
        'kelas',
        'tahun_pelajaran',
        'kompetensi_dasar',
        'kompetensi_inti',
        'tujuan_pembelajaran',
        'materi_pembelajaran',
        'asesmen_pembelajaran',
        'metode_pembelajaran',
        'media_pembelajaran',
        'sumber_belajar',
        'lampiran_belajar',
    ];

    /**
     * Get the chatbot suggestions for this RPP.
     */
    public function chatbotSuggestions()
    {
        return $this->hasMany(SaranChatbotRpp::class, 'rpp_id', 'rpp_id');
    }
}
