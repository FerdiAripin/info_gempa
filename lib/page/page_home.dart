import 'package:flutter/material.dart';

import '../fragment/fragment_dirasakan.dart';
import '../fragment/fragment_magnitudo.dart';
import '../fragment/fragment_terkini.dart';
import '../page/earthquake_guide_page.dart'; // Import halaman panduan gempa

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List _pages = [
    const FragmentTerkini(),
    const FragmentMagnitudo(),
    const FragmentDirasakan(),
  ];

  final List<Map<String, dynamic>> _tabData = [
    {
      'title': 'Gempa Terkini',
      'subtitle': 'Update real-time',
      'icon': Icons.schedule,
      'color': const Color(0xFF3B82F6), // biru terang
      'gradient': [
        const Color(0xFF3B82F6),
        const Color(0xFF2563EB)
      ] // gradasi biru
    },
    {
      'title': 'Magnitudo 5+',
      'subtitle': 'Gempa kuat',
      'icon': Icons.trending_up,
      'color': const Color(0xFFEF4444),
      'gradient': [const Color(0xFFEF4444), const Color(0xFFF97316)]
    },
    {
      'title': 'Dirasakan',
      'subtitle': 'Gempa Dirasakan',
      'icon': Icons.sensors,
      'color': const Color(0xFF10B981),
      'gradient': [const Color(0xFF10B981), const Color(0xFF059669)]
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Tambahkan ini
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7, // Batasi tinggi
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              // Wrap dengan Expanded
              child: SingleChildScrollView(
                // Tambahkan scroll
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSettingItem(Icons.language, 'Bahasa', 'Indonesia'),
                    _buildSettingItem(
                        Icons.notifications_outlined, 'Notifikasi', 'Aktif'),
                    _buildSettingItem(
                        Icons.dark_mode_outlined, 'Mode Gelap', 'Nonaktif'),
                    _buildSettingItem(
                        Icons.location_on_outlined, 'Lokasi', 'Otomatis'),
                    _buildSettingItem(
                        Icons.info_outline, 'Tentang Aplikasi', 'Versi 1.0.0'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Tambahkan ini
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7, // Batasi tinggi
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              // Wrap dengan Expanded
              child: SingleChildScrollView(
                // Tambahkan scroll
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        // Tambahkan tombol panduan gempa di header notifikasi
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Tutup bottom sheet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EarthquakeGuidePage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.security,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Card khusus untuk panduan gempa
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade50, Colors.red.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Tutup bottom sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EarthquakeGuidePage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.security,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Panduan Menghadapi Gempa',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'Pelajari cara melindungi diri saat gempa',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.red,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    _buildNotificationItem(
                      'Gempa M 5.2 Sulawesi Utara',
                      '2 menit yang lalu',
                      Icons.warning,
                      Colors.orange,
                    ),
                    _buildNotificationItem(
                      'Update data gempa terkini',
                      '15 menit yang lalu',
                      Icons.refresh,
                      Colors.blue,
                    ),
                    _buildNotificationItem(
                      'Gempa M 4.8 Jawa Barat',
                      '1 jam yang lalu',
                      Icons.info,
                      Colors.green,
                    ),
                    _buildNotificationItem(
                      'Sistem Berhasil Diperbarui',
                      '2 jam yang lalu',
                      Icons.check_circle,
                      Colors.green,
                    ),
                    // Tambah ruang di bawah untuk scroll yang lebih baik
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle,
      {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (color ?? Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color ?? Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom Header dengan status bar
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _tabData[_selectedTab]['gradient'],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Info Gempa',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'BMKG Indonesia',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Tambahkan tombol panduan gempa di header
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EarthquakeGuidePage(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.security,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: GestureDetector(
                                onTap: _showSettingsBottomSheet,
                                child: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: GestureDetector(
                                onTap: _showNotificationBottomSheet,
                                child: Stack(
                                  children: [
                                    const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Current tab info
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _animation.value)),
                          child: Opacity(
                            opacity: _animation.value,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _tabData[_selectedTab]['icon'],
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _tabData[_selectedTab]['title'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Text(
                                          _tabData[_selectedTab]['subtitle'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content area
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - _animation.value)),
                  child: Opacity(
                    opacity: _animation.value,
                    child: _pages[_selectedTab],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Modern floating tab bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            bool isSelected = _selectedTab == index;
            return GestureDetector(
              onTap: () => _changeTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: _tabData[index]['gradient'],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabData[index]['icon'],
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Text(
                        _tabData[index]['title'].split(' ')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
