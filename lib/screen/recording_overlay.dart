/*
// overlay entry point
import 'package:flutter/material.dart'; // overlay entry point

@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Container(
          color: Colors.grey,
          height: 50,
          width: 50,
          child: const Text("My overlay"),
        ),
      ),
    ),
  );
}
*/
