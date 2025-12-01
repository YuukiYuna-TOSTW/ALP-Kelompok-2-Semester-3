<?php

namespace Database\Factories;

use App\Models\ScheduleUser;
use App\Models\User;
use App\Models\Schedule;
use Illuminate\Database\Eloquent\Factories\Factory;

class ScheduleUserFactory extends Factory
{
    protected $model = ScheduleUser::class;

    public function definition()
    {
        return [
            'user_id' => User::factory(),
            'schedule_id' => Schedule::factory(),
        ];
    }
}
