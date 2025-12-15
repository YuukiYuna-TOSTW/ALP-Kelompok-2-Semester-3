<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'Nama_User' => $this->faker->unique()->userName(),
            'Email' => $this->faker->unique()->safeEmail(),
            'Password' => Hash::make('password123'),
            'Role' => $this->faker->randomElement(['Admin', 'Guru', 'Kepala_Sekolah']), // ✅ ubah 'User' menjadi 'Guru'
        ];
    }

    public function admin(): static
    {
        return $this->state([
            'Nama_User' => 'Kelompok2Admin',
            'Email' => 'Kelompok2Admin@gmail.com',
            'Password' => Hash::make('Kelompok2Admin'),
            'Role' => 'Admin',
        ]);
    }

    public function guru(): static
    {
        return $this->state([
            'Nama_User' => 'Kelompok2Guru',
            'Email' => 'Kelompok2Guru@gmail.com',
            'Password' => Hash::make('Kelompok2Guru'),
            'Role' => 'Guru',
        ]);
    }

    public function kepalaSekolah(): static
    {
        return $this->state([
            'Nama_User' => 'Kelompok2KepalaSekolah',
            'Email' => 'Kelompok2KepalaSekolah@gmail.com',
            'Password' => Hash::make('Kelompok2KepalaSekolah'),
            'Role' => 'Kepala_Sekolah',
        ]);
    }

}
