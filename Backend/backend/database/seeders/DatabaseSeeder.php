<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Schedule;
use App\Models\HistorySchedule;
use App\Models\Rpp;
use App\Models\ChatbotAi;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create users
        $users = User::factory(10)->create();

        // Create or update a specific test user (idempotent) and ensure it's in the collection
        $testUser = User::updateOrCreate(
            ['Email' => 'test@example.com'],
            [
                'Nama_User' => 'Test User',
                'Password' => Hash::make('password'),
            ]
        );

        if (! $users->contains('User_ID', $testUser->User_ID)) {
            $users->push($testUser);
        }

        // Create schedules and assign a random user for each schedule
        $schedules = Schedule::factory()->count(20)->make()->each(function ($schedule) use ($users) {
            $schedule->User_ID = $users->random()->User_ID;
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

        // Create Chatbot AI entries
        ChatbotAi::factory(10)->create();

    }
}

