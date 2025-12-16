<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Schedule extends Model
{
    use HasFactory;

    protected $table = 'Schedules';
    protected $primaryKey = 'Schedule_ID';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'Nama_Kegiatan',
        'Deskripsi',
        'Tanggal_Mulai',
        'Tanggal_Selesai',
        'Waktu_Mulai',
        'Waktu_Selesai',
        'Tempat',
        'Penyelenggara_ID',
        'Lampiran',
        'Tempat',
        'Status',
    ];

    protected $casts = [
        'Tanggal_Mulai' => 'date',
        'Tanggal_Selesai' => 'date',
        'Waktu_Mulai' => 'string',
        'Waktu_Selesai' => 'string',
    ];

    /**
     * Get the user who created this schedule.
     */
    public function penyelenggara(): BelongsTo
    {
        return $this->belongsTo(\App\Models\User::class, 'Penyelenggara_ID', 'User_ID');
    }

    /**
     * Get the users associated with this schedule (pivot table).
     */
    public function users()
    {
        return $this->belongsToMany(User::class, 'schedule_user', 'Schedule_ID', 'User_ID');
    }

    /**
     * Get the history records for this schedule.
     */
    public function histories()
    {
        return $this->hasMany(HistorySchedule::class, 'Schedule_ID', 'Schedule_ID');
    }

    /**
     * Get the chatbot suggestions for this schedule.
     */
    public function chatbotSuggestions()
    {
        return $this->hasMany(ChatbotAi::class, 'Schedule_ID', 'Schedule_ID');
    }
}
