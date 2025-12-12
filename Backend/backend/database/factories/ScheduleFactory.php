<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class ScheduleFactory extends Factory
{
    public function definition(): array
    {
        return [
            'Nama_Schedule' => $this->faker->sentence(3),
            'Penyelenggara' => User::where('Role', 'Guru')->inRandomOrder()->first()?->User_ID ?? 1, // ✅ Ambil guru
            'Tanggal_Schedule_Dimulai' => $this->faker->dateTimeBetween('+1 day', '+30 days'),
            'Tanggal_Schedule_Berakhir' => $this->faker->dateTimeBetween('+31 days', '+60 days'),
            'Jam_Schedule_Dimulai' => $this->faker->time('H:i'),
            'Jam_Schedule_Berakhir' => $this->faker->time('H:i'),
            'Deskripsi_Schedule' => $this->faker->paragraph(),
            'Dokumen' => $this->faker->word() . '.pdf',
        ];
    }
}
