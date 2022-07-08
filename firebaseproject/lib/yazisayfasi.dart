import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YaziEkrani extends StatefulWidget {
  @override
  _YaziEkraniState createState() => _YaziEkraniState();
}

class _YaziEkraniState extends State<YaziEkrani> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  yaziEkle() {
    FirebaseFirestore.instance.collection("Yazılar").doc(t1.text).set({
      'kullaniciid': auth.currentUser?.uid,
      'baslik': t1.text,
      'icerik': t2.text
    }).whenComplete(() => print("Yazı eklendi"));
  }

  yaziGuncelle() {
    FirebaseFirestore.instance
        .collection("Yazılar")
        .doc(t1.text)
        .update({'baslik': t1.text, 'icerik': t2.text}).whenComplete(
            () => print("Yazı güncellendi"));
  }

  yaziSil() {
    FirebaseFirestore.instance.collection("Yazılar").doc(t1.text).delete();
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection("Yazılar")
        .doc(t1.text)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()?['baslik'];
        gelenYaziIcerigi = gelenVeri.data()?['icerik'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Yazı Ekranı"),
        ),
        body: Container(
          margin: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: t1,
                ),
                TextField(
                  controller: t2,
                ),
                Row(
                  children: [
                    RaisedButton(child: Text("Ekle"), onPressed: yaziEkle),
                    RaisedButton(
                        child: Text("Günclle"), onPressed: yaziGuncelle),
                    RaisedButton(child: Text("Sil"), onPressed: yaziSil),
                    RaisedButton(child: Text("Getir"), onPressed: yaziGetir),
                  ],
                ),
                ListTile(
                  title: Text(gelenYaziBasligi),
                  subtitle: Text(gelenYaziIcerigi),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
