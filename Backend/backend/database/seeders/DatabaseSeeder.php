<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Schedule;
use App\Models\HistorySchedule;
use App\Models\Rpp;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // ✅ Buat 1 admin khusus menggunakan factory
        $admin = User::factory()->admin()->create();

        // ✅ Buat 1 guru khusus menggunakan factory
        $guru = User::factory()->guru()->create();

        // ✅ Buat 1 kepala sekolah khusus menggunakan factory
        $kepalaSekolah = User::factory()->kepalaSekolah()->create();

        // ✅ Buat 7 user random dengan role acak
        $randomUsers = User::factory()->count(7)->create();

        // Gabungkan semua users
        $users = collect([$admin, $guru, $kepalaSekolah])->merge($randomUsers);

        // ✅ Create schedules dengan User_ID (bukan Penyelenggara_Schedule)
        $schedules = Schedule::factory()->count(20)->create()->each(function ($schedule) use ($users) {
            $schedule->Penyelenggara = $users->random()->User_ID;
            $schedule->save();
        });

        // Create history schedules
        HistorySchedule::factory(15)->create([
            'Schedule_ID' => $schedules->random()->Schedule_ID,
        ]);

        // Create pivot table entries (Jumlah Jam Kegiatan User)
        foreach ($users->take(5) as $user) {
            $user->schedules()->attach(
                $schedules->random(3)->pluck('Schedule_ID')->toArray()
            );
        }

        // Create RPPs
        $rpp = Rpp::factory(15)->create();

    }
}

