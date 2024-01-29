import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Pengembang'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardWidget(
                imageUrl:
                    'https://raw.githubusercontent.com/MancinginAja/manja_app/main/Dito.jpg',
                name: 'Erdito Nausha Adam',
                npm: '1214031',
              ),
              SizedBox(height: 16.0),
              CardWidget(
                imageUrl:
                    'https://raw.githubusercontent.com/MancinginAja/manja_app/main/Zidan.jpg',
                name: 'M. Zidan Putra Yuliadie',
                npm: '1214043',
              ),
              SizedBox(height: 16.0),
              AppInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String npm;

  const CardWidget({
    required this.imageUrl,
    required this.name,
    required this.npm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(height: 16.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              npm,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Aplikasi Manja (MancinginAja)',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Manja adalah aplikasi katalog tempat mancing yang membantu Anda menemukan tempat mancing terbaik. Aplikasi ini memberikan informasi detail tentang lokasi, ikan yang bisa ditemui, dan rating dari tempat yang akan dikunjungi.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Gunakan Manja untuk merencanakan perjalanan mancing Anda dan temukan pengalaman mancing yang luar biasa!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
