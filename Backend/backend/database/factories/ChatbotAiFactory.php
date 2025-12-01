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
            'judul_chat' => fake()->sentence(4),
            'request_history' => fake()->text(500),
            'send_history' => fake()->text(500),
        ];
    }
}
