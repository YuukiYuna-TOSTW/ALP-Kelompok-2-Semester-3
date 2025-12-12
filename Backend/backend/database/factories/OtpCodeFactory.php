<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Carbon\Carbon;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\OtpCode>
 */
class OtpCodeFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'Email' => $this->faker->unique()->safeEmail(),
            'Kode_OTP' => $this->generateOtpCode(),
            'Expired_At' => Carbon::now()->addMinutes(5),
            'Is_Verified' => false,
        ];
    }

    /**
     * Generate a random 6-digit OTP code
     *
     * @return string
     */
    private function generateOtpCode(): string
    {
        return str_pad((string) rand(0, 999999), 6, '0', STR_PAD_LEFT);
    }

    /**
     * State for Admin user OTP
     */
    public function admin(): static
    {
        return $this->state([
            'Email' => 'Kelompok2Admin@gmail.com',
            'Kode_OTP' => $this->generateOtpCode(),
            'Expired_At' => Carbon::now()->addMinutes(5),
            'Is_Verified' => false,
        ]);
    }

    /**
     * State for Guru user OTP
     */
    public function guru(): static
    {
        return $this->state([
            'Email' => 'Kelompok2Guru@gmail.com',
            'Kode_OTP' => $this->generateOtpCode(),
            'Expired_At' => Carbon::now()->addMinutes(5),
            'Is_Verified' => false,
        ]);
    }

    /**
     * State for Kepala Sekolah user OTP
     */
    public function kepalaSekolah(): static
    {
        return $this->state([
            'Email' => 'Kelompok2KepalaSekolah@gmail.com',
            'Kode_OTP' => $this->generateOtpCode(),
            'Expired_At' => Carbon::now()->addMinutes(5),
            'Is_Verified' => false,
        ]);
    }

    /**
     * State for verified OTP
     */
    public function verified(): static
    {
        return $this->state([
            'Is_Verified' => true,
        ]);
    }

    /**
     * State for expired OTP
     */
    public function expired(): static
    {
        return $this->state([
            'Expired_At' => Carbon::now()->subMinutes(1),
        ]);
    }
}
