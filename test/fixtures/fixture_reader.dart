import 'dart:io';

String fixtureReader(String fileName) {
  return File('test/fixtures/$fileName').readAsStringSync();
}
