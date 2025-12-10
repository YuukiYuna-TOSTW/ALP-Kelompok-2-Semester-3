<?php

namespace Database\Factories;

use App\Models\Schedule;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Schedule>
 */
class ScheduleFactory extends Factory
{
    protected $model = Schedule::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'Nama_Schedule' => fake()->sentence(3),
            'Tanggal_Schedule' => fake()->date(),
            'Lokasi_Schedule' => fake()->address(),
            'Jam_Schedule' => fake()->time('H:i') . '-' . fake()->time('H:i'),
            'User_ID' => User::factory(),
            'Deskripsi_Schedule' => fake()->paragraph(),
            'Dokumen' => fake()->randomElement(['document.pdf', 'image.png', 'file.jpg', null]),
        ];
    }
}
