<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Schedule extends Model
{
    use HasFactory;

    protected $primaryKey = 'Schedule_ID';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'Nama_Schedule',
        'Tanggal_Schedule',
        'Lokasi_Schedule',
        'Jam_Schedule',
        'User_ID',
        'Deskripsi_Schedule',
        'Dokumen',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'Tanggal_Schedule' => 'date',
        ];
    }

    /**
     * Get the user who created this schedule.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'User_ID', 'User_ID');
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
