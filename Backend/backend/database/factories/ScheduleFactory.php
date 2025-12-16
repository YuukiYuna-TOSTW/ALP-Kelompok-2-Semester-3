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
        $tanggalMulai = fake()->dateTimeBetween('now', '+1 month');
        $tanggalSelesai = (clone $tanggalMulai)->modify('+' . fake()->numberBetween(1, 7) . ' days');

        return [
            'Nama_Kegiatan' => fake()->sentence(3),
            'Deskripsi' => fake()->paragraph(),
            'Tanggal_Mulai' => $tanggalMulai->format('Y-m-d'),
            'Tanggal_Selesai' => $tanggalSelesai->format('Y-m-d'),
            'Waktu_Mulai' => fake()->time('H:i:s'),
            'Waktu_Selesai' => fake()->time('H:i:s'),
            'Tempat' => fake()->city(),
            'Penyelenggara_ID' => User::factory(), // ✅ akan otomatis mengambil id
            'Lampiran' => fake()->sentence(),
            'Status' => fake()->randomElement(['Terjadwal', 'Berlangsung', 'Selesai', 'Dibatalkan']),
        ];
    }
}
