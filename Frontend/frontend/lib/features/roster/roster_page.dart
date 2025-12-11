import 'package:flutter/material.dart';

class WeeklyRosterPage extends StatefulWidget {
  const WeeklyRosterPage({super.key});

  @override
  State<WeeklyRosterPage> createState() => _WeeklyRosterPageState();
}

class _WeeklyRosterPageState extends State<WeeklyRosterPage> {
  int selectedDay = 0; // Monday default (0 index)
  late DateTime weekStart;
  
  @override
  void initState() {
    super.initState();
    // Set week start to current Monday
    final now = DateTime.now();
    weekStart = now.subtract(Duration(days: now.weekday - 1));
  }

  final List<Map<String, String>> monday = [
    {
      "code": "IMT02203301",
      "subject": "Bahasa Indonesia",
      "start": "07:30",
      "end": "08:20",
      "teacher": "Ibu Siti Nurhaliza",
    },
    {
      "code": "IMT02203302",
      "subject": "Matematika",
      "start": "08:20",
      "end": "09:10",
      "teacher": "Pak Budi Santoso",
    },
    {
      "code": "IMT02203303",
      "subject": "Bahasa Inggris",
      "start": "09:10",
      "end": "10:00",
      "teacher": "Ms. Sarah Johnson",
    },
    {
      "code": "IMT02203304",
      "subject": "Pendidikan Kewarganegaraan",
      "start": "10:00",
      "end": "11:00",
      "teacher": "Pak Ahmad Wijaya",
    },
  ];

  final List<Map<String, String>> tuesday = [
    {
      "code": "IMT02203311",
      "subject": "Biologi",
      "start": "07:30",
      "end": "08:20",
      "teacher": "Ibu Rini Puspita",
    },
    {
      "code": "IMT02203312",
      "subject": "Kimia",
      "start": "08:20",
      "end": "09:10",
      "teacher": "Pak Dimas Kurniawan",
    }
  ];

  final List<Map<String, String>> wednesday = [
    {
      "code": "IMT02203321",
      "subject": "Sejarah",
      "start": "07:30",
      "end": "08:20",
      "teacher": "Ibu Dewi Lestari",
    },
    {
      "code": "IMT02203322",
      "subject": "Geografi",
      "start": "08:20",
      "end": "09:10",
      "teacher": "Pak Hendra Gunawan",
    },
    {
      "code": "IMT02203323",
      "subject": "Sosiologi",
      "start": "09:10",
      "end": "10:00",
      "teacher": "Ibu Mega Surya",
    },
  ];

  final List<Map<String, String>> thursday = [
    {
      "code": "IMT02203331",
      "subject": "Fisika",
      "start": "07:30",
      "end": "08:20",
      "teacher": "Pak Eka Pratama",
    },
    {
      "code": "IMT02203332",
      "subject": "Pemrograman Dasar",
      "start": "08:20",
      "end": "09:10",
      "teacher": "Pak Rudi Setiawan",
    },
    {
      "code": "IMT02203333",
      "subject": "Basis Data",
      "start": "09:10",
      "end": "10:00",
      "teacher": "Pak Fajar Hidayat",
    },
    {
      "code": "IMT02203334",
      "subject": "Sistem Operasi",
      "start": "10:00",
      "end": "11:00",
      "teacher": "Pak Irwan Malik",
    },
  ];

  final List<Map<String, String>> friday = [
    {
      "code": "IMT02203341",
      "subject": "Agama",
      "start": "07:30",
      "end": "08:20",
      "teacher": "Pak Harun Nasution",
    },
    {
      "code": "IMT02203342",
      "subject": "Olahraga",
      "start": "08:20",
      "end": "09:10",
      "teacher": "Pak Hendra Kusuma",
    },
  ];

  // Saturday & Sunday empty
  final List<Map<String, String>> saturday = [];
  final List<Map<String, String>> sunday = [];

  // DAY SELECTOR
  List<String> dayNames = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];

  List<int> get dayDate {
    return List.generate(7, (index) {
      return weekStart.add(Duration(days: index)).day;
    });
  }

  List<Map<String, String>> get todaySchedule {
    switch (selectedDay) {
      case 0:
        return monday;
      case 1:
        return tuesday;
      case 2:
        return wednesday;
      case 3:
        return thursday;
      case 4:
        return friday;
      case 5:
        return saturday;
      case 6:
        return sunday;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER WITH BACK BUTTON
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF5DADE2),
                    const Color(0xFF3498DB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Jadwal Minggu Ini",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // DAY SELECTOR (HORIZONTAL SCROLL - CENTERED)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(7, (index) {
                        final bool active = index == selectedDay;
                        final blueShades = [
                          const Color(0xFFAED6F1), // Light blue pastel
                          const Color(0xFF85C1E2), // Light blue
                          const Color(0xFF5DADE2), // Medium blue
                          const Color(0xFF3498DB), // Blue
                          const Color(0xFF2980B9), // Darker blue
                          const Color(0xFF1F618D), // Dark blue
                          const Color(0xFFD6EAF8), // Very light blue pastel
                        ];

                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedDay = index);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 85,
                            decoration: BoxDecoration(
                              gradient: active
                                  ? LinearGradient(
                                      colors: [
                                        blueShades[index],
                                        blueShades[index].withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: active ? null : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: active
                                      ? blueShades[index].withOpacity(0.3)
                                      : Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                              border: active
                                  ? null
                                  : Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayNames[index],
                                  style: TextStyle(
                                    color: active ? Colors.white : Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dayDate[index].toString(),
                                  style: TextStyle(
                                    color: active ? Colors.white : Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            // SUBJECT CARDS (HORIZONTAL SCROLL)
            Expanded(
              child: todaySchedule.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tidak Ada Jadwal",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: List.generate(
                          todaySchedule.length,
                          (index) {
                            final item = todaySchedule[index];
                            final blueColors = [
                              const Color(0xFF85C1E2), // Light blue
                              const Color(0xFF5DADE2), // Medium blue
                              const Color(0xFF3498DB), // Blue
                              const Color(0xFF2980B9), // Darker blue
                            ];
                            final cardColor = blueColors[index % blueColors.length];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardColor.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          cardColor,
                                          cardColor.withOpacity(0.85),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // LEFT SIDE - TIME
                                        Container(
                                          width: 80,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.25),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Waktu",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "${item['start']} - ${item['end']}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // RIGHT SIDE - INFO
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item["subject"]!,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          "ID: ${item['code']}",
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(0.8),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      "${index + 1}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.person_outline,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        item["teacher"]!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}