import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
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
  int _currentIndex = 0;

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
        _filteredKosList = kosList;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xFF6F4F28),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile.jpg'),
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Welcome",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 35,
              child: TextField(
                onChanged: _filterKos,
                decoration: InputDecoration(
                  hintText: 'Cari kos...',
                  hintStyle: TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.search, size: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
                    horizontal: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        toolbarHeight: 130,
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
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Container(
                        height: 80,
                        color: Color(0xFF6F4F28),
                      ),
                    ),
                    Column(
                      children: [
                        CarouselSlider(
                          items: [
                            'assets/images/banner_0.jpg',
                            'assets/images/banner_1.jpg',
                            'assets/images/banner_2.jpg',
                            'assets/images/banner_3.jpg',
                          ].map((imagePath) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 160,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 6),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.easeInOut,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Silahkan memilih kos',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 0.8,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                  ),
                )
              ],
            ),
    );
  }
}
