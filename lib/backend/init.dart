import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path_provider/path_provider.dart';

final sembastProvider =
    Provider<Future<Database>>((ref) => SembastInit().database);

class SembastInit {
  static final SembastInit _instance =
      SembastInit._internal(); // Singleton instance
  static Database? _database;

  SembastInit._internal(); // Private Constructor

  factory SembastInit() {
    return _instance;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      return databaseFactoryWeb.openDatabase('nexus-chats.db');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = join(dir.path, 'nexus-chats.db');
      return databaseFactoryIo.openDatabase(dbPath);
    }
  }
}
