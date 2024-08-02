
import 'package:flutter/material.dart';

class AyarlarEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      // Profile photo change logic here
                    },
                    child: Text(
                      'Profil Fotoğrafını Değiştir',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 40, thickness: 1, color: Colors.grey[400]),
            Text(
              'Kullanıcı Bilgileri',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'İsim',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Soyisim',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kullanıcı Adı',
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'E-posta',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save button logic here
                },
                child: Text('Kaydet'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
