<?php

namespace Database\Factories;

use App\Models\SaranChatbotRpp;
use App\Models\Rpp;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\SaranChatbotRpp>
 */
class SaranChatbotRppFactory extends Factory
{
    protected $model = SaranChatbotRpp::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'rpp_id' => Rpp::factory(),
        ];
    }
}
