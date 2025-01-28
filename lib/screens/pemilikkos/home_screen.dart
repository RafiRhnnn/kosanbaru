import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allKos = [];
  List<Map<String, dynamic>> _filteredKos = [];

  @override
  void initState() {
    super.initState();
    _fetchKosData();
  }

  Future<void> _fetchKosData() async {
    try {
      final response =
          await Supabase.instance.client.from('tambahkos').select();
      final List<Map<String, dynamic>> kosList =
          List<Map<String, dynamic>>.from(response);
      setState(() {
        _allKos = kosList;
        _filteredKos = kosList;
      });
    } catch (e) {
      debugPrint('Error fetching kos data: $e');
    }
  }

  void _filterKos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredKos = _allKos;
      } else {
        _filteredKos = _allKos
            .where((kos) => kos['nama_kos']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.brown,
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
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
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Icon(Icons.search, color: Colors.grey),
                            ),
                            Expanded(
                              child: TextField(
                                cursorHeight: 20,
                                autofocus: false,
                                decoration: const InputDecoration(
                                  hintText: "Cari kos...",
                                  border: InputBorder.none,
                                ),
                                onChanged: _filterKos,
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
            const SizedBox(height: 20),
            Expanded(
              child: _filteredKos.isEmpty
                  ? const Center(child: Text('Belum ada data kos'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _filteredKos.length,
                      itemBuilder: (context, index) {
                        final kos = _filteredKos[index];

                        return GestureDetector(
                          onTap: () => _showKosDetail(context, kos),
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
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKosDetail(BuildContext context, Map<String, dynamic> kosData) {
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
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
