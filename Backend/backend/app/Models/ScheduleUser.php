<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ScheduleUser extends Model
{
    use HasFactory;

    protected $table = 'Schedule_User';

    // No single auto-incrementing primary key on pivot table
    public $incrementing = false;
    public $timestamps = true;

    protected $fillable = [
        'User_ID',
        'Schedule_ID',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'User_ID', 'User_ID');
    }

    public function schedule()
    {
        return $this->belongsTo(Schedule::class, 'Schedule_ID', 'Schedule_ID');
    }
}
