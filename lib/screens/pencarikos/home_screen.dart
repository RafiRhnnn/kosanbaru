import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onKosTap;

  const HomeScreen({super.key, required this.onKosTap});

  @override
  Widget build(BuildContext context) {
    // Ganti `fetchKosData` dengan FutureBuilder serupa
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchKosData(),
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
              onTap: () => onKosTap(kos),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Future<List<Map<String, dynamic>>> fetchKosData() async {
    // Simpan fungsi fetchKosData di sini
    try {
      final response =
          await Supabase.instance.client.from('tambahkos').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching kos data: $e');
      return [];
    }
  }
}
