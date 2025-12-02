<?php

namespace Database\Factories;

use App\Models\Rpp;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Rpp>
 */
class RppFactory extends Factory
{
    protected $model = Rpp::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'Nama_Mata_Pelajaran' => fake()->randomElement(['Matematika', 'Bahasa Indonesia', 'IPA', 'IPS', 'Bahasa Inggris']),
            'Kelas' => fake()->randomElement(['VII', 'VIII', 'IX', 'X', 'XI', 'XII']),
            'Tahun_Pelajaran' => fake()->randomElement(['2024/2025', '2025/2026']),
            'Kompetensi_Dasar' => fake()->sentence(10),
            'Kompetensi_Inti' => fake()->sentence(10),
            'Tujuan_Pembelajaran' => fake()->paragraph(),
            'Materi_Pembelajaran' => fake()->paragraph(),
            'Asesmen_Pembelajaran' => fake()->paragraph(),
            'Metode_Pembelajaran' => fake()->randomElement(['Ceramah', 'Diskusi', 'Praktikum', 'Project Based Learning']),
            'Media_Pembelajaran' => fake()->randomElement(['PowerPoint', 'Video', 'Buku', 'Internet']),
            'Sumber_Belajar' => fake()->sentence(),
            'Lampiran_Belajar' => fake()->sentence(),
        ];
    }
}
