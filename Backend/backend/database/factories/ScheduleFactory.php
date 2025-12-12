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
            'Penyelenggara_ID' => $this->faker->randomElement(User::pluck('User_ID')->toArray()),
            'Tanggal_Schedule_Dimulai' => $this->faker->date(),
            'Tanggal_Schedule_Berakhir' => $this->faker->date(),
            'Jam_Schedule_Dimulai' => $this->faker->time('H:i'),
            'Jam_Schedule_Berakhir' => $this->faker->time('H:i'),
            'Deskripsi_Schedule' => $this->faker->paragraph(),
            'Dokumen' => $this->faker->word() . '.pdf',
        ];
    }
}
