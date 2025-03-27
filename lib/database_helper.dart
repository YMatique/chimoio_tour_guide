import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/tourist_spot.dart';
import 'models/restaurant.dart';
import 'models/event.dart';
import 'models/transport.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chimoio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabela de Pontos Turísticos
    await db.execute('''
    CREATE TABLE tourist_spots (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL
    )
    ''');
    await db.insert(
      'tourist_spots',
      TouristSpot(
        name: 'Monte Bengo',
        description: 'Formação rochosa com vista panorâmica',
        latitude: -19.1167,
        longitude: 33.4833,
      ).toMap(),
    );
    await db.insert(
      'tourist_spots',
      TouristSpot(
        name: 'Lago Chicamba',
        description: 'Lago para pesca e passeios',
        latitude: -19.3667,
        longitude: 33.6667,
      ).toMap(),
    );
    await db.insert(
      'tourist_spots',
      TouristSpot(
        name: 'Catedral de Nossa Senhora das Dores',
        description: 'Igreja histórica no centro de Chimoio',
        latitude: -19.1050,
        longitude: 33.4600,
      ).toMap(),
    );
    await db.insert(
      'tourist_spots',
      TouristSpot(
        name: 'Mercado Central de Chimoio',
        description: 'Mercado vibrante com artesanato e produtos locais',
        latitude: -19.1120,
        longitude: 33.4700,
      ).toMap(),
    );
    await db.insert(
      'tourist_spots',
      TouristSpot(
        name: 'Parque dos Professores',
        description: 'Área verde para lazer e piqueniques',
        latitude: -19.1200,
        longitude: 33.4750,
      ).toMap(),
    );

    // Tabela de Restaurantes
    await db.execute('''
    CREATE TABLE restaurants (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      cuisine TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL
    )
    ''');
    await db.insert(
      'restaurants',
      Restaurant(
        name: 'Chicateco Restaurant',
        cuisine: 'Moçambicana',
        latitude: -19.1160,
        longitude: 33.4820,
      ).toMap(),
    );
    await db.insert(
      'restaurants',
      Restaurant(
        name: 'Restaurante InterChimoio',
        cuisine: 'Internacional',
        latitude: -19.1100,
        longitude: 33.4650,
      ).toMap(),
    );
    await db.insert(
      'restaurants',
      Restaurant(
        name: 'Café Moçambique',
        cuisine: 'Café e Lanches',
        latitude: -19.1080,
        longitude: 33.4680,
      ).toMap(),
    );
    await db.insert(
      'restaurants',
      Restaurant(
        name: 'Sabores do Manica',
        cuisine: 'Moçambicana e Portuguesa',
        latitude: -19.1150,
        longitude: 33.4780,
      ).toMap(),
    );
    await db.insert(
      'restaurants',
      Restaurant(
        name: 'Pizzaria Chimanimani',
        cuisine: 'Italiana',
        latitude: -19.1180,
        longitude: 33.4800,
      ).toMap(),
    );

    // Tabela de Eventos
    await db.execute('''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      dateTime TEXT NOT NULL,
      location TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL
    )
    ''');
    await db.insert(
      'events',
      Event(
        name: 'Festival Monte Bengo',
        dateTime: '2025-11-15 14:00',
        location: 'Monte Bengo',
        latitude: -19.1167,
        longitude: 33.4833,
      ).toMap(),
    );
    await db.insert(
      'events',
      Event(
        name: 'Feira de Artesanato',
        dateTime: '2025-04-10 09:00',
        location: 'Mercado Central',
        latitude: -19.1120,
        longitude: 33.4700,
      ).toMap(),
    );
    await db.insert(
      'events',
      Event(
        name: 'Corrida de Chimoio',
        dateTime: '2025-06-25 07:00',
        location: 'Parque dos Professores',
        latitude: -19.1200,
        longitude: 33.4750,
      ).toMap(),
    );
    await db.insert(
      'events',
      Event(
        name: 'Noite Cultural Moçambicana',
        dateTime: '2025-08-20 18:00',
        location: 'Catedral de Chimoio',
        latitude: -19.1050,
        longitude: 33.4600,
      ).toMap(),
    );

    // Tabela de Transporte
    await db.execute('''
    CREATE TABLE transports (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      route TEXT NOT NULL,
      description TEXT NOT NULL
    )
    ''');
    await db.insert(
      'transports',
      Transport(
        route: 'Chimoio - Manica',
        description: 'Chapa saindo do terminal central, a cada 30 min.',
      ).toMap(),
    );
    await db.insert(
      'transports',
      Transport(
        route: 'Chimoio - Beira',
        description: 'Ônibus diário às 06:00 e 14:00 do terminal rodoviário.',
      ).toMap(),
    );
    await db.insert(
      'transports',
      Transport(
        route: 'Chimoio - Vila Pery',
        description: 'Chapa saindo da praça central, a cada hora.',
      ).toMap(),
    );
    await db.insert(
      'transports',
      Transport(
        route: 'Chimoio - Aeroporto',
        description: 'Moto-táxi disponível 24h na estação central.',
      ).toMap(),
    );
  }

  Future<List<TouristSpot>> getTouristSpots() async {
    final db = await database;
    final result = await db.query('tourist_spots');
    return result.map((map) => TouristSpot.fromMap(map)).toList();
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await database;
    final result = await db.query('restaurants');
    return result.map((map) => Restaurant.fromMap(map)).toList();
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    final result = await db.query('events');
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<List<Transport>> getTransports() async {
    final db = await database;
    final result = await db.query('transports');
    return result.map((map) => Transport.fromMap(map)).toList();
  }
}
