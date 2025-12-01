<?php

namespace Database\Factories;

use App\Models\SaranChatbotSchedule;
use App\Models\Schedule;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\SaranChatbotSchedule>
 */
class SaranChatbotScheduleFactory extends Factory
{
    protected $model = SaranChatbotSchedule::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'schedule_id' => Schedule::factory(),
        ];
    }
}
