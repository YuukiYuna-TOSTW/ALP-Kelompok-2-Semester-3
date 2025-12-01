<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ChatbotAi extends Model
{
    use HasFactory;

    protected $primaryKey = 'chat_id';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'judul_chat',
        'request_history',
        'send_history',
    ];
}
