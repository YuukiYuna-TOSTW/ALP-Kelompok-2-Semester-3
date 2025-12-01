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
            'nama_schedule' => fake()->sentence(3),
            'tanggal_schedule' => fake()->date(),
            'lokasi_schedule' => fake()->address(),
            'jam_schedule' => fake()->time('H:i') . '-' . fake()->time('H:i'),
            'user_id' => User::factory(),
            'deskripsi_schedule' => fake()->paragraph(),
            'dokumen' => fake()->randomElement(['document.pdf', 'image.png', 'file.jpg', null]),
        ];
    }
}
