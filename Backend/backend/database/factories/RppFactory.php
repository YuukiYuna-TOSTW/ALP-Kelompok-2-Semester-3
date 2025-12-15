<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class RppFactory extends Factory
{
    public function definition(): array
    {
        return [
            'Nama_Mata_Pelajaran' => $this->faker->randomElement(['Matematika', 'IPA', 'IPS', 'Bahasa Indonesia', 'Bahasa Inggris']),
            'Kelas' => $this->faker->randomElement(['VII', 'VIII', 'IX']),
            'Bab/Materi' => $this->faker->sentence(3),
            'Semester' => $this->faker->randomElement(['Ganjil', 'Genap']),
            'Kompetensi_Dasar' => $this->faker->paragraph(),
            'Kompetensi_Inti' => $this->faker->paragraph(),
            'Tujuan_Pembelajaran' => $this->faker->paragraph(),
        ];
    }
}
