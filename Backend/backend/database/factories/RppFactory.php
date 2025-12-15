<?php

namespace Database\Factories;

use App\Models\Rpp;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Rpp>
 */
class RppFactory extends Factory
{
    protected $model = Rpp::class;

    public function definition(): array
    {
        return [
            'User_ID' => User::factory(),
            'Nama_Mata_Pelajaran' => fake()->randomElement(['Matematika','IPA','IPS','Bahasa Indonesia','Bahasa Inggris','PJOK']),
            'Kelas' => fake()->randomElement(['7A','7B','8A','8B','9A','9B']),
            'Bab/Materi' => fake()->sentence(3),
            'Semester' => fake()->randomElement(['Ganjil','Genap']),
            'Kompetensi_Dasar' => fake()->paragraph(),
            'Kompetensi_Inti' => fake()->paragraph(),
            'Tujuan_Pembelajaran' => fake()->paragraph(),
            'Status' => fake()->randomElement(['Menunggu Review','Minta Revisi','Ditolak']), // ✅ selaraskan dengan enum migrasi
        ];
    }
}
