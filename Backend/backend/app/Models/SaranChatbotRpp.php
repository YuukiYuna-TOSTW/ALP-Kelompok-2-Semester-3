<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SaranChatbotRpp extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'rpp_id',
    ];

    /**
     * Get the RPP that this suggestion references.
     */
    public function rpp()
    {
        return $this->belongsTo(Rpp::class, 'rpp_id', 'rpp_id');
    }
}
