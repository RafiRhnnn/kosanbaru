import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_screen.dart'; // Pastikan ini mengarah ke file tambah_screen.dart

class PemilikKosScreen extends StatefulWidget {
  final String email;

  const PemilikKosScreen({super.key, required this.email});

  @override
  State<PemilikKosScreen> createState() => _PemilikKosScreenState();
}

class _PemilikKosScreenState extends State<PemilikKosScreen> {
  late Future<List<Map<String, dynamic>>> _kosList;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _kosList = fetchKosData();
  }

  Future<List<Map<String, dynamic>>> fetchKosData() async {
    try {
      final response = await Supabase.instance.client
          .from('tambahkos')
          .select()
          .eq('email_pengguna', widget.email);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching kos data: $e');
      return [];
    }
  }

  void _showKosDetail(Map<String, dynamic> kosData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(kosData['nama_kos'] ?? 'Detail Kos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/kosan.jpg'),
              const SizedBox(height: 8),
              Text('Alamat: ${kosData['alamat_kos'] ?? ''}'),
              Text('Jumlah Kamar: ${kosData['jumlah_kamar'] ?? ''}'),
              Text('Harga Sewa: Rp ${kosData['harga_sewa'] ?? ''}/bulan'),
              Text('Jenis Kos: ${kosData['jenis_kos'] ?? ''}'),
              Text('Fasilitas: ${kosData['fasilitas'] ?? ''}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Pemilik Kos'),
      ),
      body: _currentIndex == 2
          ? FutureBuilder<List<Map<String, dynamic>>>(
              future: _kosList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada data kos'));
                }

                final kosList = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: kosList.length,
                  itemBuilder: (context, index) {
                    final kos = kosList[index];

                    return GestureDetector(
                      onTap: () => _showKosDetail(kos),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.asset(
                                  'assets/images/kosan.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                kos['nama_kos'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text(
                  _currentIndex == 0
                      ? 'Halaman Home'
                      : _currentIndex == 1
                          ? 'Halaman Statistik'
                          : 'Halaman Profile',
                  style: const TextStyle(fontSize: 20)),
            ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahScreen(email: widget.email),
                  ),
                );
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.bar_chart),
            title: const Text('Statistik'),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add),
            title: const Text('Tambah'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
