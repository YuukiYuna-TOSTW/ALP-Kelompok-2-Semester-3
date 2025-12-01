<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Schedule extends Model
{
    use HasFactory;

    protected $primaryKey = 'schedule_id';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'nama_schedule',
        'tanggal_schedule',
        'lokasi_schedule',
        'jam_schedule',
        'user_id',
        'deskripsi_schedule',
        'dokumen',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'tanggal_schedule' => 'date',
        ];
    }

    /**
     * Get the user who created this schedule.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    /**
     * Get the users associated with this schedule (pivot table).
     */
    public function users()
    {
        return $this->belongsToMany(User::class, 'schedule_user', 'schedule_id', 'user_id');
    }

    /**
     * Get the history records for this schedule.
     */
    public function histories()
    {
        return $this->hasMany(HistorySchedule::class, 'schedule_id', 'schedule_id');
    }

    /**
     * Get the chatbot suggestions for this schedule.
     */
    public function chatbotSuggestions()
    {
        return $this->hasMany(SaranChatbotSchedule::class, 'schedule_id', 'schedule_id');
    }
}
