<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rpp extends Model
{
    use HasFactory;

    protected $table = 'rpps';
    protected $primaryKey = 'id';

    protected $fillable = [
        'User_ID',
        'Nama_RPP',
        'Kelas',
        'KD',
        'KI',
        'Tujuan',
        'Pendahuluan',
        'Inti',
        'Penutup',
        'Catatan',
        'Status',
    ];

    // ✅ Relasi ke User
    public function user()
    {
        return $this->belongsTo(User::class, 'User_ID');
    }

    // ✅ Relasi ke RppReview
    public function reviews()
    {
        return $this->hasMany(RppReview::class, 'RPP_ID');
    }
}
