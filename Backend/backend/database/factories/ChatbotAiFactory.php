<?php

namespace Database\Factories;

use App\Models\ChatbotAi;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\ChatbotAi>
 */
class ChatbotAiFactory extends Factory
{
    protected $model = ChatbotAi::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'Judul_Chat' => fake()->sentence(4),
            'Request_History' => fake()->text(500),
            'Send_History' => fake()->text(500),
        ];
    }
}
