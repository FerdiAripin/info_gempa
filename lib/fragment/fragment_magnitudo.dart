import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ripple_wave/ripple_wave.dart';

import '../tools/tools.dart';

class FragmentMagnitudo extends StatefulWidget {
  const FragmentMagnitudo({super.key});

  @override
  State<FragmentMagnitudo> createState() => _FragmentMagnitudoState();
}

class _FragmentMagnitudoState extends State<FragmentMagnitudo> {
  List listDataTerkini = [];
  List filteredDataTerkini = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    getData(); // Panggil getData di initState
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredDataTerkini = listDataTerkini;
        isSearching = false;
      } else {
        filteredDataTerkini = listDataTerkini.where((item) {
          return item['Wilayah']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }).toList();
        isSearching = true;
      }
    });
  }

  Future<void> getData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      var url =
          Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          listDataTerkini = data['Infogempa']['gempa'];
          filteredDataTerkini = listDataTerkini; // Initialize filtered data
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  String _getPotentialSeverity(String potensi) {
    String lowerPotensi = potensi.toLowerCase();

    if (lowerPotensi.contains('tidak') || lowerPotensi.contains('no')) {
      return 'Sedang';
    } else if (lowerPotensi.contains('tsunami')) {
      return 'Tinggi';
    } else {
      return 'Rendah';
    }
  }

  Color _getPotentialColor(String potensi) {
    String severity = _getPotentialSeverity(potensi);
    switch (severity) {
      case 'Tinggi':
        return Colors.red;
      case 'Sedang':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan wilayah...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontFamily: 'Poppins',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSearchResultsHeader() {
    if (!isSearching) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
                children: [
                  const TextSpan(text: 'Menampilkan '),
                  TextSpan(
                    text: '${filteredDataTerkini.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' hasil untuk '),
                  TextSpan(
                    text: '"${searchController.text}"',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
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
          // Search Bar
          _buildSearchBar(),

          // Search Results Header
          _buildSearchResultsHeader(),

          // Main Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: getData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (filteredDataTerkini.isEmpty && searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data gempa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'untuk wilayah "${searchController.text}"',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: getData,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: filteredDataTerkini.length,
        itemBuilder: (context, index) {
          var currentData = filteredDataTerkini[index];
          var latlong = currentData['Coordinates']!.split(',');
          double dlatitude = double.parse(latlong[0]);
          double dlongitude = double.parse(latlong[1]);

          double dJarak = Geolocator.distanceBetween(VariableGlobal.strLatitude,
              VariableGlobal.strLongitude, dlatitude, dlongitude);
          double distanceInKiloMeters = dJarak / 1000;
          double roundDistanceInKM =
              double.parse((distanceInKiloMeters).toStringAsFixed(2));

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isDismissible: true,
                enableDrag: true,
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Header
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      double.parse(currentData['Magnitude']) >=
                                              6
                                          ? Colors.red[50]
                                          : Colors.orange[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.vibration,
                                  color:
                                      double.parse(currentData['Magnitude']) >=
                                              6
                                          ? Colors.red[600]
                                          : Colors.orange[600],
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Detail Gempa",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      "Informasi magnitudo terbaru",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon:
                                    Icon(Icons.close, color: Colors.grey[600]),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                // Magnitude Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: double.parse(
                                                  currentData['Magnitude']) >=
                                              6
                                          ? [Colors.red[400]!, Colors.red[600]!]
                                          : [
                                              Colors.orange[400]!,
                                              Colors.orange[600]!
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (double.parse(currentData[
                                                        'Magnitude']) >=
                                                    6
                                                ? Colors.red[200]!
                                                : Colors.orange[200]!)
                                            .withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        currentData['Magnitude'],
                                        style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const Text(
                                        "Magnitudo",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          double.parse(currentData[
                                                      'Magnitude']) >=
                                                  6
                                              ? "Gempa Kuat"
                                              : "Gempa Sedang",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Stats Grid
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        icon: Icons.straighten,
                                        label: "Kedalaman",
                                        value: currentData['Kedalaman'],
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        icon: Icons.location_pin,
                                        label: "Koordinat",
                                        value:
                                            "${currentData['Lintang']}, ${currentData['Bujur']}",
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Potensi Card - Special highlighting
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: _getPotentialColor(
                                            currentData['Potensi'])
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _getPotentialColor(
                                              currentData['Potensi'])
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: _getPotentialColor(
                                                  currentData['Potensi'])
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.warning_rounded,
                                          color: _getPotentialColor(
                                              currentData['Potensi']),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Potensi Bahaya",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700],
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: _getPotentialColor(
                                                        currentData['Potensi']),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    _getPotentialSeverity(
                                                        currentData['Potensi']),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              currentData['Potensi'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1E293B),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Information Cards
                                _buildInfoCard(
                                  icon: Icons.access_time_rounded,
                                  title: "Waktu Kejadian",
                                  content:
                                      SetTime.setTime(currentData['DateTime']),
                                  color: Colors.indigo,
                                ),

                                const SizedBox(height: 16),

                                _buildInfoCard(
                                  icon: Icons.location_city_rounded,
                                  title: "Lokasi Episenter",
                                  content: currentData['Wilayah'],
                                  color: Colors.teal,
                                ),

                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: double.parse(currentData['Magnitude']) >= 6
                        ? Colors.redAccent
                        : Color(0xfffb8936),
                    width: 5,
                  ),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        isThreeLine: true,
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(
                            width: 90,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                RippleWave(
                                  color:
                                      double.parse(currentData['Magnitude']) >=
                                              6
                                          ? Colors.redAccent
                                          : Color(0xfffb8936),
                                  repeat: true,
                                  child: const SizedBox(),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    currentData['Magnitude'],
                                    style: TextStyle(
                                        color: double.parse(
                                                    currentData['Magnitude']) >=
                                                6
                                            ? Colors.redAccent
                                            : Color(0xfffb8936),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                              ],
                            )),
                        title: Text(
                          currentData['Wilayah'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.redAccent, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                      SetTime.setTime(currentData['DateTime']),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Poppins')),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const SizedBox(
                            height: double.infinity,
                            child: Icon(Icons.keyboard_arrow_right_outlined)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
