<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rpp extends Model
{
    use HasFactory;

    protected $table = 'rpps';
    protected $primaryKey = 'RPP_ID';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'Nama_Mata_Pelajaran',
        'Kelas',
        'Bab/Materi',
        'Semester',
        'Kompetensi_Dasar',
        'Kompetensi_Inti',
        'Tujuan_Pembelajaran',
    ];

    /**
     * Get the chatbot suggestions for this RPP.
     */
    public function chatbotSuggestions()
    {
        return $this->hasMany(ChatbotAi::class, 'RPP_ID', 'RPP_ID');
    }
}
