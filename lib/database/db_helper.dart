import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dam_u3_practica1/models/materia.dart'; 
import 'package:dam_u3_practica1/models/tarea.dart'; 

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._privateConstructor();

  DBHelper._privateConstructor();

Future<Database> get database async {
  if (_database != null) {
    return _database!;
  }
  _database = await _initDatabase();
  return _database!;
}

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'tu_base_de_datos.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE materias(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        semestre TEXT,
        docente TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tareas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idMateria INTEGER,
        fechaEntrega TEXT,
        descripcion TEXT
      )
    ''');
  }
  Future<int> insertMateria(Materia materia) async {
  final db = await database;
  return await db.insert(
    'materias',
    materia.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
} // insert materias
 Future<List<Materia>> getMaterias() async {
    final db = await database;
    final List<Map<String, dynamic>> materiasMapList = await db.query('materias');

    final materiasList = <Materia>[];

    for (final materiaMap in materiasMapList) {
      materiasList.add(Materia.fromMap(materiaMap)); 
    }

    return materiasList;
  }  // get materias

  Future<int> updateMateria(Materia materia) async {
  final db = await database;
  return await db.update(
    'materias',
    materia.toMap(),
    where: 'id = ?',
    whereArgs: [materia.id],
  );
}// update materias
Future<Materia?> getMateriaById(int id) async {
  final db = await database;
  final List<Map<String, dynamic>> materiasMapList = await db.query(
    'materias',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (materiasMapList.isEmpty) {
    return null;
  }

  final materiaMap = materiasMapList.first;
  return Materia.fromMap(materiaMap);
}// materia por id

Future<int> deleteMateria(int id) async {
  final db = await database;
  return await db.delete(
    'materias',
    where: 'id = ?',
    whereArgs: [id],
  );
}//eliminar materia por id 


 Future<int> insertTarea(Tarea tarea) async {
  final db = await database;
  return await db.insert(
    'tareas',
    tarea.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}// insertar tarea

  Future<List<Tarea>> getTareas() async {
    final db = await database;
    final List<Map<String, dynamic>> tareasMapList = await db.query('tareas');

    final tareasList = <Tarea>[];

    for (final tareaMap in tareasMapList) {
      tareasList.add(Tarea(
        id: tareaMap['id'],
        idMateria: tareaMap['idMateria'],
        fechaEntrega: tareaMap['fechaEntrega'],
        descripcion: tareaMap['descripcion'],
      ));
    } 

    return tareasList;
  } // get tarea

  Future<int> updateTarea(Tarea tarea) async {
    final db = await database;
    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  } // actualizar tarea por id

  Future<Tarea?> getTareaById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> tareasMapList = await db.query(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (tareasMapList.isEmpty) {
      return null;
    }

    final tareaMap = tareasMapList.first;
    return Tarea(
      id: tareaMap['id'],
      idMateria: tareaMap['idMateria'],
      fechaEntrega: tareaMap['fechaEntrega'],
      descripcion: tareaMap['descripcion'],
    );
  }

  Future<int> deleteTarea(int id) async {
    final db = await database;
    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }// eliminar tarea por id

}



