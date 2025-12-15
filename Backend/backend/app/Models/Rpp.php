<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rpp extends Model
{
    use HasFactory;

    protected $table = 'rpps';
    protected $primaryKey = 'id';
    public $timestamps = true;

    protected $fillable = [
        'User_ID',
        'Nama_Mata_Pelajaran',
        'Kelas',
        'Bab/Materi',
        'Semester',
        'Kompetensi_Dasar',
        'Kompetensi_Inti',
        'Tujuan_Pembelajaran',
        'Pendahuluan',
        'Kegiatan_Inti',
        'Penutup',
        'Catatan_Tambahan',
        'Status',
    ];

    // ✅ Relasi ke User
    public function user()
    {
        return $this->belongsTo(User::class, 'User_ID');
    }

}