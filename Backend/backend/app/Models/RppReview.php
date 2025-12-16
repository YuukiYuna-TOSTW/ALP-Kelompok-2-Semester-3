<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RppReview extends Model
{
    use HasFactory;

    protected $table = 'kepsek_rpp_reviewer';
    protected $primaryKey = 'Reviewer_ID';
    public $timestamps = false;

    protected $fillable = [
        'RPP_ID',
        'Reviewer_Kompetensi_Dasar',
        'Reviewer_Kompetensi_Inti',
        'Reviewer_Tujuan_Pembelajaran',
        'Reviewer_Pendahuluan',
        'Reviewer_Kegiatan_Inti',
        'Reviewer_Penutup',
        'Reviewer_Catatan_Tambahan',
    ];

    // Relasi ke RPP
    public function rpp()
    {
        return $this->belongsTo(Rpp::class, 'RPP_ID', 'RPP_ID');
    }
}