class RoleAccess {
  // ==============================================
  // JADWAL
  // ==============================================

  static bool canManageSchedule(String role) {
    return role == "admin";
  }

  static bool canViewAllSchedule(String role) {
    return role == "admin" || role == "wakasek" || role == "kepsek";
  }

  static bool canViewOwnSchedule(String role) {
    return role == "guru";
  }

  // ==============================================
  // RPP
  // ==============================================

  static bool canEditRPP(String role) {
    return role == "guru"; // hanya guru edit RPP-nya sendiri
  }

  static bool canReviewRPP(String role) {
    return role == "wakasek" || role == "kepsek";
  }

  static bool canSeeAllRPP(String role) {
    return role == "admin" || role == "wakasek" || role == "kepsek";
  }

  static bool canSeeOwnRPP(String role) {
    return role == "guru";
  }

  // ==============================================
  // USER MANAGEMENT
  // ==============================================

  static bool canManageUsers(String role) {
    return role == "admin";
  }
}
