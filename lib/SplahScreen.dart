import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_project/HomePgae.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
            image: NetworkImage(
                'https://media2.giphy.com/media/3o85xscgnCWS8Xxqik/giphy.gif?cid=ecf05e47lca5m2863ii9ouw5klp10aaspsnw0545ab54e9c5&ep=v1_gifs_related&rid=giphy.gif')),
      ),
    );
  }
}
