import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../rpp/layout/rpp_layout.dart';

class NotificationPage extends StatefulWidget {
  final String role;

  const NotificationPage({super.key, required this.role});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  /// Dummy notifications
  List<Map<String, dynamic>> notifications = [
    {
      "title": "Pengumuman Baru",
      "description": "Rapat Koordinasi Guru akan diadakan besok pukul 09:00.",
      "time": "12 Februari 2025 08:45",
      "isRead": false,
    },
    {
      "title": "RPP Direvisi",
      "description": "RPP Bab 3 membutuhkan revisi dari Kepala Sekolah.",
      "time": "11 Februari 2025 16:20",
      "isRead": false,
    },
    {
      "title": "Survey Baru",
      "description": "Mohon mengisi survey kepuasan mengajar periode 2025-1.",
      "time": "10 Februari 2025 10:10",
      "isRead": true,
    },
  ];

  final Color unreadSoftBlue = const Color(0xFFE6F0FF);

  @override
  Widget build(BuildContext context) {
    final int unreadCount = notifications
        .where((n) => n["isRead"] == false)
        .length;

    return RppLayout(
      role: widget.role,
      selectedRoute: "/notifications",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _mainCard(unreadCount),
        ),
      ),
    );
  }

  // ============================================================
  // MAIN CARD (HEADER MENTOK + CONTENT)
  // ============================================================
  Widget _mainCard(int unreadCount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(unreadCount),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _historyLabel(),
                const SizedBox(height: 14),

                ...notifications
                    .asMap()
                    .entries
                    .map((e) => _notifCard(e.key, e.value))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER (TANPA BACK BUTTON)
  // ============================================================
  Widget _cardHeader(int unread) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          const Text(
            "Notification Center",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "$unread unread",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // HISTORY LABEL
  // ============================================================
  Widget _historyLabel() {
    return Row(
      children: const [
        Icon(Icons.history, size: 18, color: Colors.grey),
        SizedBox(width: 6),
        Text(
          "Previous 30 days notification(s)",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  // ============================================================
  // NOTIFICATION ITEM
  // ============================================================
  Widget _notifCard(int index, Map<String, dynamic> n) {
    final bool isRead = n["isRead"] ?? false;
    final String title = (n["title"] ?? "").toString().toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          notifications[index]["isRead"] = true;
        });

        // 🔔 JIKA PENGUMUMAN
        if (title.contains("pengumuman")) {
          Navigator.pushNamed(
            context,
            "/announcement/detail",
            arguments: {
              "judul": n["title"],
              "isi": n["description"],
              "tanggal": n["time"],
            },
          );
          return;
        }

        // 🔔 DEFAULT → DETAIL NOTIFIKASI
        Navigator.pushNamed(context, "/notifications/detail", arguments: n);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : unreadSoftBlue,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead
                ? Colors.grey.shade300
                : AppColors.primary.withOpacity(.3),
          ),
          boxShadow: isRead
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 40,
                  color: AppColors.primary.withOpacity(.85),
                ),
                if (!isRead)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n["title"] ?? "-",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n["description"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        n["time"] ?? "",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
