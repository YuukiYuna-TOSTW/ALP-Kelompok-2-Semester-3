<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\OtpCode;

class OtpCodeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create OTP for Admin
        OtpCode::factory()->admin()->create();

        // Create OTP for Guru
        OtpCode::factory()->guru()->create();

        // Create OTP for Kepala Sekolah
        OtpCode::factory()->kepalaSekolah()->create();

        // Create 10 random OTP codes for testing
        OtpCode::factory()->count(10)->create();
    }
}
