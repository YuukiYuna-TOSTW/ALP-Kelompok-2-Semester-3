<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OtpCode extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'otp_codes';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'Email',
        'Kode_OTP',
        'Expired_At',
        'Is_Verified',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'Expired_At' => 'datetime',
        'Is_Verified' => 'boolean',
    ];

    /**
     * Check if OTP is expired
     *
     * @return bool
     */
    public function isExpired(): bool
    {
        return now()->greaterThan($this->Expired_At);
    }

    /**
     * Check if OTP is valid
     *
     * @param string $code
     * @return bool
     */
    public function isValid(string $code): bool
    {
        return $this->Kode_OTP === $code && !$this->isExpired() && !$this->Is_Verified;
    }

    /**
     * Get the user that owns the OTP
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'Email', 'Email');
    }
}
