<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Schedule;
use App\Models\HistorySchedule;
use App\Models\Rpp;
use App\Models\ChatbotAi;
use App\Models\SaranChatbotSchedule;
use App\Models\SaranChatbotRpp;
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
        // Create users
        $users = User::factory(10)->create();

        // Create a specific test user
        $testUser = User::factory()->create([
            'nama_user' => 'Test User',
            'email' => 'test@example.com',
        ]);

        // Create schedules for users
        $schedules = Schedule::factory(20)->create([
            'user_id' => $users->random()->user_id,
        ]);

        // Create history schedules
        HistorySchedule::factory(15)->create([
            'schedule_id' => $schedules->random()->schedule_id,
        ]);

        // Create pivot table entries (Jumlah Jam Kegiatan User)
        foreach ($users->take(5) as $user) {
            $user->schedules()->attach(
                $schedules->random(3)->pluck('schedule_id')->toArray()
            );
        }

        // Create RPPs
        $rpps = Rpp::factory(15)->create();

        // Create Chatbot AI entries
        ChatbotAi::factory(10)->create();

        // Create Saran Chatbot Schedule
        SaranChatbotSchedule::factory(10)->create([
            'schedule_id' => $schedules->random()->schedule_id,
        ]);

        // Create Saran Chatbot RPP
        SaranChatbotRpp::factory(10)->create([
            'rpp_id' => $rpps->random()->rpp_id,
        ]);
    }
}

