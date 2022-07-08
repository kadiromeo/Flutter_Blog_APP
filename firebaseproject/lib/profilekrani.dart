import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseproject/yazisayfasi.dart';
import 'package:firebaseproject/main.dart';
import 'package:firebaseproject/videoplayer.dart';
import 'package:firebaseproject/videoresim.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'anasayfa.dart';

class ProfilEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Sayfası"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => VideoApp()),
                  (Route<dynamic> route) => true);
            },
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => Iskele()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => VideoResim()),
                (Route<dynamic> route) => true);
          }),
      body: ProfilTasarimi(),
    );
  }
}

class ProfilTasarimi extends StatefulWidget {
  @override
  _ProfilTasarimiState createState() => _ProfilTasarimiState();
}

class _ProfilTasarimiState extends State<ProfilTasarimi> {
  late File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String indirmeBaglantisi;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png")
        .getDownloadURL();

    setState(() {
      indirmeBaglantisi = baglanti;
    });
  }

  kameradanYukle() async {
    var alinanDosya = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      yuklenecekDosya = File(alinanDosya!.path);
    });

    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png");

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    String url = await (yuklemeGorevi.then((res) => res.ref.getDownloadURL()));
    setState(() {
      indirmeBaglantisi = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipOval(
              child: indirmeBaglantisi == null
                  ? Text("Resim Yok")
                  : Image.network(indirmeBaglantisi,
                      width: 100, height: 100, fit: BoxFit.cover)),
          RaisedButton(child: Text("Resim Yükle"), onPressed: kameradanYukle)
        ],
      ),
    );
  }
}
