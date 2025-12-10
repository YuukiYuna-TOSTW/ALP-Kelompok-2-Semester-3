// File ini kosong untuk struktur, karena controller OTP tidak digunakan dalam form
// Anda bisa menambahkan controller untuk form nanti jika diperlukan

class EventController {
  // Contoh controller untuk form kegiatan
  String? validateJudul(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Judul wajib diisi' : null;
  }

  String? validatePenyelenggara(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;
  }

  String? validateDeskripsi(String? value) {
    return (value == null || value.trim().isEmpty)
        ? 'Deskripsi wajib diisi'
        : null;
  }
}
