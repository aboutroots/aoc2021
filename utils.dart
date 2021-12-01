import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<String>> readlines(String filename) async {
  String path = './inputs/$filename';
  File f = new File(path);
  return await f
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();
}
