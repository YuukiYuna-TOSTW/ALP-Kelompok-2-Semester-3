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
            'nama_mata_pelajaran' => fake()->randomElement(['Matematika', 'Bahasa Indonesia', 'IPA', 'IPS', 'Bahasa Inggris']),
            'kelas' => fake()->randomElement(['VII', 'VIII', 'IX', 'X', 'XI', 'XII']),
            'tahun_pelajaran' => fake()->randomElement(['2024/2025', '2025/2026']),
            'kompetensi_dasar' => fake()->sentence(10),
            'kompetensi_inti' => fake()->sentence(10),
            'tujuan_pembelajaran' => fake()->paragraph(),
            'materi_pembelajaran' => fake()->paragraph(),
            'asesmen_pembelajaran' => fake()->paragraph(),
            'metode_pembelajaran' => fake()->randomElement(['Ceramah', 'Diskusi', 'Praktikum', 'Project Based Learning']),
            'media_pembelajaran' => fake()->randomElement(['PowerPoint', 'Video', 'Buku', 'Internet']),
            'sumber_belajar' => fake()->sentence(),
            'lampiran_belajar' => fake()->sentence(),
        ];
    }
}
