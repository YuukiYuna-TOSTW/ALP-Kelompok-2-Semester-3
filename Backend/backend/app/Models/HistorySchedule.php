<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HistorySchedule extends Model
{
    use HasFactory;

    protected $primaryKey = 'History_Schedule_ID';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'Schedule_ID',
        'Tanggal_History_Schedule',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'Tanggal_History_Schedule' => 'date',
        ];
    }

    /**
     * Get the schedule that this history belongs to.
     */
    public function schedule()
    {
        return $this->belongsTo(Schedule::class, 'Schedule_ID', 'Schedule_ID');
    }
}
