<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    protected $table = 'users';
    protected $primaryKey = 'id'; // ✅ primary key adalah 'id'

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
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'Password' => 'hashed',
        ];
    }

    // ✅ Relasi: User sebagai penyelenggara (one-to-many)
    public function schedulesAsOrganizer()
    {
        return $this->hasMany(Schedule::class, 'Penyelenggara_ID', 'id');
    }

    // ✅ Relasi: User sebagai peserta (many-to-many)
    public function schedules()
    {
        return $this->belongsToMany(Schedule::class, 'schedule_user', 'User_ID', 'Schedule_ID');
    }

    // ✅ Relasi ke RPP
    public function rpps()
    {
        return $this->hasMany(Rpp::class, 'User_ID', 'id');
    }
}
