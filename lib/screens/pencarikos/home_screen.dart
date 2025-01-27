import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onKosTap;

  const HomeScreen({super.key, required this.onKosTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _kosList = [];
  List<Map<String, dynamic>> _filteredKosList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchKosData();
  }

  Future<void> _fetchKosData() async {
    try {
      final response =
          await Supabase.instance.client.from('tambahkos').select();
      final kosList = List<Map<String, dynamic>>.from(response);
      setState(() {
        _kosList = kosList;
        _filteredKosList = kosList; // Awalnya, semua data ditampilkan
      });
    } catch (e) {
      debugPrint('Error fetching kos data: $e');
    }
  }

  void _filterKos(String query) {
    final filteredList = _kosList.where((kos) {
      final namaKos = kos['nama_kos']?.toLowerCase() ?? '';
      return namaKos.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredKosList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, // Mengatur background menjadi warna abu-abu
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.yellow,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Welcome Pencari',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 8), // Kurangi jarak antar elemen
            SizedBox(
              height: 32, // Tinggi kotak pencarian lebih kecil
              child: TextField(
                onChanged: _filterKos,
                decoration: InputDecoration(
                  hintText: 'Cari kos...',
                  hintStyle: TextStyle(
                      fontSize: 12), // Ukuran teks placeholder lebih kecil
                  prefixIcon:
                      const Icon(Icons.search, size: 16), // Ikon lebih kecil
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Border lebih kecil
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8, // Padding horizontal lebih kecil
                  ),
                ),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12), // Jarak bawah di bagian header
          ],
        ),
        toolbarHeight: 90, // Kurangi tinggi AppBar
      ),
      body: _filteredKosList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada kos yang ditemukan',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView(
              children: [
                const SizedBox(height: 40),
                // Banner Slider (CarouselSlider)
                CarouselSlider(
                  items: [
                    'assets/images/banner_0.jpg',
                    'assets/images/banner_1.jpg',
                    'assets/images/banner_2.jpg',
                    'assets/images/banner_3.jpg',
                  ].map((imagePath) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10), // Sudut melengkung
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 160, // Tinggi tetap
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.easeInOut,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                ),
                const SizedBox(height: 40),

                // *** Menambahkan Teks "Silahkan memilih kos" ***
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Silahkan memilih kos', // Teks yang ditambahkan
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold, // Membuat teks menjadi tebal
                            fontSize: 18, // Ukuran teks
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *** GridView Kos List ***
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _filteredKosList.length,
                  itemBuilder: (context, index) {
                    final kos = _filteredKosList[index];
                    return GestureDetector(
                      onTap: () => widget.onKosTap(kos),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Image.asset(
                                  'assets/images/kosan.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    kos['nama_kos'] ?? 'Kos Tanpa Nama',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${kos['harga_sewa'] ?? 'N/A'}/bulan',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
