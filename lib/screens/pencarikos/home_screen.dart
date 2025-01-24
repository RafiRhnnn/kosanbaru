import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Welcome Pencari',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              onChanged: _filterKos,
              decoration: InputDecoration(
                hintText: 'Cari nama kos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        toolbarHeight: 130,
      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredKosList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada kos yang ditemukan',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        color: Colors.grey,
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
          ),
        ],
      ),
    );
  }
}
