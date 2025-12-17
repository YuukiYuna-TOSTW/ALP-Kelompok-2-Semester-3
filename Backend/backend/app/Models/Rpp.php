<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Rpp extends Model
{
    use HasFactory;

    protected $table = 'rpps';
    protected $primaryKey = 'RPP_ID'; // ✅ penting: Laravel tahu primary key
    public $incrementing = true;
    protected $keyType = 'int';

    // ✅ Tambahkan konstanta status
    const STATUS_MENUNGGU_REVIEW = 'Menunggu Review';
    const STATUS_MINTA_REVISI = 'Minta Revisi';
    const STATUS_REVISI = 'Revisi';
    const STATUS_DISETUJUI = 'Disetujui';

    protected $fillable = [
        'User_ID',
        'Nama_Mata_Pelajaran',
        'Kelas',
        'Semester',
        'Bab/Materi',
        'Kompetensi_Dasar',
        'Kompetensi_Inti',
        'Tujuan_Pembelajaran',
        'Pendahuluan',
        'Kegiatan_Inti',
        'Penutup',
        'Materi_Pembelajaran',
        'Asesmen_Pembelajaran',
        'Metode_Pembelajaran',
        'Media_Pembelajaran',
        'Sumber_Belajar',
        'Lampiran',
        'Catatan_Tambahan',
        'Status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'User_ID', 'id');
    }
}