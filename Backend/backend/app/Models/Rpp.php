<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rpp extends Model
{
    use HasFactory;

    protected $table = 'rpps';
    protected $primaryKey = 'RPP_ID';
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
        'Materi_Pembelajaran',
        'Asesmen_Pembelajaran',
        'Metode_Pembelajaran',
        'Media_Pembelajaran',
        'Sumber_Belajar',
        'Lampiran',
        'Catatan_Tambahan',
        'Status',
    ];

    // ✅ Relasi ke User
    public function user()
    {
        return $this->belongsTo(User::class, 'User_ID');
    }
    public const STATUS_MENUNGGU_REVIEW = 'Menunggu Review'; // jika Anda pakai label ini
    public const STATUS_MINTA_REVISI    = 'Minta Revisi';
    public const STATUS_REVISI          = 'Revisi';
    public const STATUS_DISETUJUI       = 'Disetujui';

    public function reviews()
    {
        return $this->hasMany(RppReview::class, 'RPP_ID', 'RPP_ID');
    }

    protected static function booted()
    {
        static::updated(function (Rpp $rpp) {
            $nullifyStatuses = [
                self::STATUS_MENUNGGU_REVIEW,
                self::STATUS_MINTA_REVISI,
                self::STATUS_REVISI,
                self::STATUS_DISETUJUI,
            ];

            if (in_array($rpp->Status, $nullifyStatuses, true)) {
                $rpp->reviews()->update([
                    'Reviewer_Kompetensi_Dasar'      => null,
                    'Reviewer_Kompetensi_Inti'       => null,
                    'Reviewer_Tujuan_Pembelajaran'   => null,
                    'Reviewer_Pendahuluan'           => null,
                    'Reviewer_Kegiatan_Inti'         => null,
                    'Reviewer_Penutup'               => null,
                    'Reviewer_Catatan_Tambahan'      => null,
                ]);
            }
        });
    }
}