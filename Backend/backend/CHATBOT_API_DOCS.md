# Dokumentasi API Chatbot Gemini

## Overview

Controller ini menyediakan API untuk berinteraksi dengan Google Gemini AI menggunakan API key yang sudah dikonfigurasi di file `.env`.

## Konfigurasi

### 1. Environment Variables

Pastikan file `.env` sudah memiliki:

```env
GEMINI_API_KEY=your_api_key_here
```

### 2. Config Services

Konfigurasi Gemini telah ditambahkan ke `config/services.php`:

```php
'gemini' => [
    'api_key' => env('GEMINI_API_KEY'),
    'base_url' => 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent',
],
```

## Endpoints API

### 1. Validate API Key

**GET** `/api/chatbot/validate-key`

Mengecek apakah Gemini API key tersedia dan valid.

**Response Success:**

```json
{
    "status": "success",
    "message": "API Key tersedia",
    "data": {
        "api_key_exists": true,
        "api_key_length": 39
    }
}
```

**Response Error:**

```json
{
    "status": "error",
    "message": "Gemini API Key tidak ditemukan dalam konfigurasi",
    "data": null
}
```

### 2. Send Message to Gemini AI

**POST** `/api/chatbot/send-message`

Mengirim pesan ke Gemini AI dan mendapat respons.

**Request Body:**

```json
{
    "message": "Halo, bagaimana cara belajar programming?"
}
```

**Validation Rules:**

-   `message`: required|string|max:1000

**Response Success:**

```json
{
    "status": "success",
    "message": "Pesan berhasil dikirim ke Gemini AI",
    "data": {
        "user_message": "Halo, bagaimana cara belajar programming?",
        "ai_response": "Untuk belajar programming, Anda bisa mulai dengan...",
        "timestamp": "2025-12-03T10:30:00.000000Z"
    }
}
```

**Response Error (API Key tidak ada):**

```json
{
    "status": "error",
    "message": "Gemini API Key tidak dikonfigurasi",
    "data": null
}
```

**Response Error (Gemini API Error):**

```json
{
    "status": "error",
    "message": "Gagal berkomunikasi dengan Gemini AI",
    "data": {
        "error_code": 400,
        "error_message": "API key not valid"
    }
}
```

### 3. Get API Information

**GET** `/api/chatbot/info`

Mendapat informasi konfigurasi dan endpoint yang tersedia.

**Response:**

```json
{
    "status": "success",
    "message": "Informasi konfigurasi API",
    "data": {
        "gemini_configured": true,
        "base_url": "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent",
        "endpoints": {
            "validate_key": "/api/chatbot/validate-key",
            "send_message": "/api/chatbot/send-message",
            "get_info": "/api/chatbot/info"
        }
    }
}
```

## Cara Testing

### 1. Test dengan cURL

**Validate API Key:**

```bash
curl -X GET http://localhost:8000/api/chatbot/validate-key
```

**Send Message:**

```bash
curl -X POST http://localhost:8000/api/chatbot/send-message \
  -H "Content-Type: application/json" \
  -d '{"message": "Halo Gemini AI!"}'
```

**Get API Info:**

```bash
curl -X GET http://localhost:8000/api/chatbot/info
```

### 2. Test dengan Postman atau Insomnia

1. **Base URL:** `http://localhost:8000`
2. **Headers:** `Content-Type: application/json`
3. **Body (untuk send-message):** Raw JSON

## Error Handling

Controller ini menangani berbagai jenis error:

1. **Validation Error** (400): Input tidak valid
2. **Configuration Error** (500): API key tidak dikonfigurasi
3. **API Error** (status sesuai Gemini API): Error dari Gemini API
4. **Server Error** (500): Error server internal

## Security Notes

1. API key disimpan di file `.env` dan tidak pernah diekspos ke client
2. Validasi input dilakukan untuk mencegah injection
3. Logging error dilakukan untuk debugging
4. Timeout 30 detik untuk mencegah hanging request

## Integration dengan Frontend Flutter

Untuk mengintegrasikan dengan Flutter app, gunakan package `http` atau `dio`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> sendMessageToAI(String message) async {
  final response = await http.post(
    Uri.parse('http://your-server.com/api/chatbot/send-message'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'message': message}),
  );

  return json.decode(response.body);
}
```
