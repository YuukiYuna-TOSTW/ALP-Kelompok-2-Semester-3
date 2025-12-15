<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Schedule;
use App\Models\HistorySchedule;
use App\Models\Rpp;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {

        // Buat users lainnya
        $admin = User::factory()->admin()->create();
        $guru = User::factory()->guru()->create();
        $kepalaSekolah = User::factory()->kepalaSekolah()->create();
        $randomUsers = User::factory()->count(7)->create();

        // ✅ Gabungkan semua users termasuk reviewer
        $users = collect([$admin, $guru, $kepalaSekolah])->merge($randomUsers);
        $guruUsers = $users->where('Role', 'Guru');

        // Create schedules dengan Penyelenggara_ID
        $schedules = Schedule::factory()->count(20)->create([
            'Penyelenggara_ID' => fn() => $users->random()->id,
        ]);

        // Create history schedules
        HistorySchedule::factory(15)->create([
            'Schedule_ID' => fn() => $schedules->random()->Schedule_ID,
        ]);

        // Attach users ke schedules (many-to-many)
        foreach ($users->take(5) as $user) {
            $user->schedules()->attach(
                $schedules->random(3)->pluck('Schedule_ID')->toArray()
            );
        }

        // Create RPPs untuk guru
        foreach ($guruUsers as $guru) {
            Rpp::factory()->count(rand(2, 4))->create([
                'User_ID' => $guru->id,
            ]);
        }

        if ($guruUsers->isEmpty()) {
            Rpp::factory(15)->create([
                'User_ID' => fn() => $users->random()->id,
            ]);
        }
    }
}





