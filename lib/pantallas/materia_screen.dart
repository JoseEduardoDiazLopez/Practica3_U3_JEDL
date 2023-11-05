
import 'package:flutter/material.dart';
import 'package:dam_u3_practica1/models/materia.dart';
import 'package:dam_u3_practica1/database/db_helper.dart';

class AgregarMateriaScreen extends StatefulWidget {
  @override
  _AgregarMateriaScreenState createState() => _AgregarMateriaScreenState();
}

class _AgregarMateriaScreenState extends State<AgregarMateriaScreen> {
  // Declaración de controladores para los campos de entrada
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController semestreController = TextEditingController();
  final TextEditingController docenteController = TextEditingController();
  final TextEditingController nombreController2 = TextEditingController();
  final TextEditingController semestreController2 = TextEditingController();
  final TextEditingController docenteController2 = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController idControllerEliminar = TextEditingController();
  
  List<Materia> materias = [];

  void _guardarMateria() async {
    final nombre = nombreController.text;
    final semestre = semestreController.text;
    final docente = docenteController.text;
  
    if (nombre.isNotEmpty && semestre.isNotEmpty && docente.isNotEmpty) {
      Materia nuevaMateria = Materia(
        nombre: nombre,
        semestre: semestre,
        docente: docente,
      );

      final id = await DBHelper.instance.insertMateria(nuevaMateria);

      if (id != null) {
        print("Materia insertada con éxito");
        _limpiarCampos();
         _cargarMaterias();
        // Materia insertada con éxito
      } else {
        // Hubo un error al insertar la materia,
      }
    } else {
      // Los campos no pueden estar vacíos
    }
  }
void _limpiarCampos() {
  nombreController.clear();
  semestreController.clear();
  docenteController.clear();
  nombreController2.clear();
  semestreController2.clear();
  docenteController2.clear();
  idController.clear();
  idControllerEliminar.clear();
}
  Future<void> _cargarMaterias() async {
    final materiasList = await DBHelper.instance.getMaterias();
    setState(() {
      materias = materiasList;
    });
  }

  void _buscarMateriaPorId() async {
    final id = idController.text;

    if (id.isNotEmpty) {
      final materia = await DBHelper.instance.getMateriaById(int.parse(id));

      if (materia != null) {
        // Puedes utilizar los datos de la materia encontrada para llenar los campos de actualización.
        nombreController2.text = materia.nombre ?? "";
        semestreController2.text = materia.semestre ?? "";
        docenteController2.text = materia.docente ?? "";
      } else {
        // No se encontró ninguna materia con el ID proporcionado, puedes mostrar un mensaje al usuario.
      }
    } else {
      // El campo de ID no puede estar vacío, puedes mostrar un mensaje al usuario.
    }
  }

  void _actualizarMateria() async {
    final nombre = nombreController2.text;
    final semestre = semestreController2.text;
    final docente = docenteController2.text;
    final id = idController.text;

    if (id.isNotEmpty &&
        nombre.isNotEmpty &&
        semestre.isNotEmpty &&
        docente.isNotEmpty) {
      Materia materiaActualizada = Materia(
        id: int.parse(id),
        nombre: nombre,
        semestre: semestre,
        docente: docente,
        
      );

      final rowsUpdated =
          await DBHelper.instance.updateMateria(materiaActualizada);

      if (rowsUpdated > 0) {
        print("Materia actualizada con éxito");
        _limpiarCampos();
         _cargarMaterias();
        // Materia actualizada con éxito
      } else {
        // Hubo un error al actualizar la materia
      }
    } else {
      // Los campos no pueden estar vacíos
    }
  }

  void _eliminarMateriaPorId() async {
    final id = idControllerEliminar.text;
    

    if (id.isNotEmpty) {
      final result = await DBHelper.instance.deleteMateria(int.parse(id));

      if (result != null) {
        print("Materia eliminada con éxito");
        _limpiarCampos();
         _cargarMaterias();
      } else {}
    } else {}
  }
  @override
  void initState() {
    super.initState();
    _cargarMaterias();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Cambiar la longitud a 4
      child: Scaffold(
        appBar: AppBar(
          title: Text('MATERIAS'),
        backgroundColor: Colors.grey,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ver'),
              Tab(text: 'Nuevo'),
              Tab(text: 'Actualizar'),
              Tab(text: 'Eliminar'), // Agregado el Tab de "Eliminar"
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña "Ver"
           Padding(
  padding: const EdgeInsets.all(16.0),
  child: ListView.builder(
    itemCount: materias.length,
    itemBuilder: (context, index) {
      final materia = materias[index];
      return Card(
        child: ListTile(
          title: Text(materia.nombre ?? 'Nombre no disponible'),
          subtitle: Text(
            'ID: ${materia.id} - Semestre: ${materia.semestre ?? 'Semestre no disponible'} - Docente: ${materia.docente ?? 'Docente no disponible'}',
          ),
        ),
      );
    },
  ),
),

            // Contenido de la pestaña "Nuevo"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Agregar Nueva Materia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                // Campo de entrada para el nombre de la materia
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre de la Materia'),
            ),
            // Campo de entrada para el semestre
            TextField(
              controller: semestreController,
              decoration: InputDecoration(labelText: 'Semestre'),
            ),
            // Campo de entrada para el nombre del docente
            TextField(
              controller: docenteController,
              decoration: InputDecoration(labelText: 'Nombre del Docente'),
            ),
            // Botón para guardar la materia
            ElevatedButton(
              onPressed: _guardarMateria ,
              child: Text('Crear Materia'),
            ),
            
             
                ],
              ),
            ),
            // Contenido de la pestaña "Actualizar"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
               
                  
                  // Contenido de la pestaña "Buscar/Actualizar Materia"
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Buscar Materia Por ID',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Campo de entrada para buscar una materia por ID
                        TextField(
                          controller: idController,
                          decoration:
                              InputDecoration(labelText: 'ID de la Materia'),
                        ),
                        ElevatedButton(
                          onPressed: _buscarMateriaPorId,
                          child: Text('Buscar Materia por ID'),
                        ),
                        // Campos de entrada para actualizar la materia
                        TextField(
                          controller: nombreController2,
                          decoration: InputDecoration(
                              labelText: 'Nombre de la Materia'),
                        ),
                        TextField(
                          controller: semestreController2,
                          decoration: InputDecoration(labelText: 'Semestre'),
                        ),
                        TextField(
                          controller: docenteController2,
                          decoration:
                              InputDecoration(labelText: 'Nombre del Docente'),
                        ),
                        // Botón para actualizar la materia
                        ElevatedButton(
                          onPressed: _actualizarMateria,
                          child: Text('Actualizar Materia'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Contenido de la pestaña "Eliminar"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Eliminar Materia Por ID',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Campo de entrada para eliminar una materia por ID
                  TextField(
                    controller: idControllerEliminar,
                    decoration: InputDecoration(
                        labelText: 'ID de la Materia a Eliminar'),
                  ),
                  ElevatedButton(
                    onPressed: _eliminarMateriaPorId,
                    child: Text('Eliminar Materia por ID'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
