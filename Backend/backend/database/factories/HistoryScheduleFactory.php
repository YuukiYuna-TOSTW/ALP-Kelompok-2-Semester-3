<?php

namespace Database\Factories;

use App\Models\HistorySchedule;
use App\Models\Schedule;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\HistorySchedule>
 */
class HistoryScheduleFactory extends Factory
{
    protected $model = HistorySchedule::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'schedule_id' => Schedule::factory(),
            'tanggal_history_schedule' => fake()->date(),
        ];
    }
}
