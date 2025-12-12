<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    protected $primaryKey = 'User_ID';

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'Nama_User',
        'Email',
        'Password',
        'Role',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'Password',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'Password' => 'hashed',
        ];
    }

    /**
     * Get the schedules created by this user.
     */
    public function createdSchedules()
    {
        return $this->hasMany(Schedule::class, 'User_ID', 'User_ID');
    }

    /**
     * Get the schedules this user is associated with (pivot table).
     */
    public function schedules()
    {
        return $this->belongsToMany(Schedule::class, 'schedule_user', 'User_ID', 'Schedule_ID');
    }
}
