import 'package:flutter/material.dart';

class EarthquakeGuidePage extends StatefulWidget {
  const EarthquakeGuidePage({super.key});

  @override
  State<EarthquakeGuidePage> createState() => _EarthquakeGuidePageState();
}

class _EarthquakeGuidePageState extends State<EarthquakeGuidePage>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  // Track which sections are expanded
  final Map<int, bool> _expandedSections = {
    0: false, // Sebelum Gempa
    1: false, // Saat Gempa - Dalam Ruangan
    2: false, // Saat Gempa - Luar Ruangan
    3: false, // Setelah Gempa
  };

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _shakeAnimation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Quick Stats
                    _buildQuickStatsCard(),

                    const SizedBox(height: 24),

                    // Section Title
                    _buildSectionTitle('Panduan Keselamatan'),

                    const SizedBox(height: 16),

                    // Accordion Sections
                    _buildAccordionSection(
                      index: 0,
                      title: 'Sebelum Gempa',
                      subtitle: 'Persiapan dan Mitigasi',
                      icon: Icons.schedule_rounded,
                      color: const Color(0xFF1565C0),
                      items: [
                        'Siapkan tas darurat berisi air minum, makanan kaleng, obat-obatan, senter, dan radio',
                        'Pelajari lokasi tempat berlindung teraman di rumah (di bawah meja kokoh, kusen pintu)',
                        'Identifikasi jalur evakuasi dan titik kumpul terdekat',
                        'Amankan barang-barang berat yang dapat jatuh (lemari, rak buku)',
                        'Pelajari cara mematikan gas, listrik, dan air',
                        'Buat rencana komunikasi dengan keluarga',
                        'Ikuti simulasi gempa bumi secara berkala',
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildAccordionSection(
                      index: 1,
                      title: 'Saat Gempa - Dalam Ruangan',
                      subtitle: 'Tindakan DROP, COVER, HOLD ON',
                      icon: Icons.home_rounded,
                      color: const Color(0xFFE65100),
                      items: [
                        'DROP - Jatuhkan diri ke tangan dan lutut',
                        'COVER - Berlindung di bawah meja atau lindungi kepala dengan tangan',
                        'HOLD ON - Pegang pegangan yang kuat sampai guncangan berhenti',
                        'Jangan berlari keluar saat gempa masih berlangsung',
                        'Jauhi jendela, cermin, dan benda yang dapat jatuh',
                        'Jika tidak ada meja, lindungi kepala dan leher dengan tangan',
                        'Jangan menggunakan lift',
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildAccordionSection(
                      index: 2,
                      title: 'Saat Gempa - Luar Ruangan',
                      subtitle: 'Cari Area Terbuka dan Aman',
                      icon: Icons.landscape_rounded,
                      color: const Color(0xFF2E7D32),
                      items: [
                        'Cari area terbuka, jauh dari bangunan, pohon, dan kabel listrik',
                        'Jika sedang berkendara, berhenti perlahan dan tetap di dalam kendaraan',
                        'Hindari jembatan, flyover, dan terowongan',
                        'Jauhi lereng yang curam (risiko longsor)',
                        'Jika di pantai, segera ke dataran tinggi (risiko tsunami)',
                        'Tetap waspada terhadap benda jatuh dari bangunan',
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildAccordionSection(
                      index: 3,
                      title: 'Setelah Gempa',
                      subtitle: 'Tindakan Pascagempa',
                      icon: Icons.health_and_safety_rounded,
                      color: const Color(0xFF7B1FA2),
                      items: [
                        'Periksa diri sendiri dan orang lain dari cedera',
                        'Berikan pertolongan pertama jika diperlukan',
                        'Periksa kerusakan bangunan sebelum masuk kembali',
                        'Matikan gas, listrik, dan air jika ada kerusakan',
                        'Waspada terhadap gempa susulan',
                        'Dengarkan informasi dari radio atau media resmi',
                        'Jangan menyebarkan berita yang belum jelas kebenarannya',
                        'Hubungi keluarga untuk mengonfirmasi keadaan',
                        'Jika rumah rusak, segera keluar dan cari tempat aman',
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Emergency Information
                    _buildSectionTitle('Informasi Darurat'),

                    const SizedBox(height: 16),

                    _buildEmergencyNumbersCard(),

                    const SizedBox(height: 20),

                    _buildPreparednessKitCard(),

                    const SizedBox(height: 20),

                    _buildTipsCard(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFD32F2F),
      foregroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Panduan Gempa Bumi',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Kesiapsiagaan adalah Kunci Keselamatan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              'Persiapan yang baik dapat menyelamatkan nyawa Anda dan keluarga',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
                '90 Detik', 'Waktu Emas\nEvakuasi', Icons.timer_outlined),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatItem(
                '24 Jam', 'Persediaan\nMinimal', Icons.inventory_outlined),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatItem('3 Menit', 'Durasi Rata-rata\nGempa Besar',
                Icons.schedule_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFFD32F2F)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD32F2F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccordionSection({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    final isExpanded = _expandedSections[index] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedSections[index] = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 24,
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
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expandable Content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: items
                    .asMap()
                    .map((itemIndex, item) => MapEntry(
                          itemIndex,
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: color.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${itemIndex + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Color(0xFF2A2A2A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .values
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumbersCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomor Darurat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hubungi segera saat darurat',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildEmergencyNumber(
                    'Polisi', '110', Icons.local_police_outlined),
                _buildEmergencyNumber(
                    'Ambulans', '119', Icons.local_hospital_outlined),
                _buildEmergencyNumber('Pemadam Kebakaran', '113',
                    Icons.local_fire_department_outlined),
                _buildEmergencyNumber(
                    'SAR Basarnas', '115', Icons.sos_outlined),
                _buildEmergencyNumber(
                    'BNPB', '117', Icons.account_balance_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparednessKitCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.backpack_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kit Darurat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Barang wajib untuk keadaan darurat',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildKitItem(
                    'Air minum (3 liter per orang)', Icons.water_drop_outlined),
                _buildKitItem(
                    'Makanan kaleng dan snack', Icons.fastfood_outlined),
                _buildKitItem(
                    'Obat-obatan dan P3K', Icons.medical_services_outlined),
                _buildKitItem(
                    'Senter dan baterai', Icons.flashlight_on_outlined),
                _buildKitItem('Radio darurat', Icons.radio_outlined),
                _buildKitItem('Pakaian ganti', Icons.checkroom_outlined),
                _buildKitItem('Uang tunai', Icons.payments_outlined),
                _buildKitItem('Dokumen penting', Icons.description_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips Penting',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kiat-kiat untuk keselamatan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTipItem('Latihan rutin drop, cover, hold on',
                    Icons.fitness_center_outlined),
                _buildTipItem('Simpan sepatu di dekat tempat tidur',
                    Icons.run_circle_outlined),
                _buildTipItem('Pastikan pintu mudah dibuka',
                    Icons.door_front_door_outlined),
                _buildTipItem(
                    'Dokumen dalam wadah kedap air', Icons.folder_outlined),
                _buildTipItem(
                    'Kenali karakteristik bangunan', Icons.home_work_outlined),
                _buildTipItem('Tetap tenang dan jangan panik',
                    Icons.self_improvement_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumber(String service, String number, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFD32F2F), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              service,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitItem(String item, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
