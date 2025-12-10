<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ChatbotAi extends Model
{
    use HasFactory;

    protected $primaryKey = 'Chat_ID';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'Judul_Chat',
        'Request_History',
        'Send_History',
    ];
}
