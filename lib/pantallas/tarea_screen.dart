import 'package:dam_u3_practica1/database/db_helper.dart';
import 'package:dam_u3_practica1/models/tarea.dart';
import 'package:flutter/material.dart';

class AgregarTareaScreen extends StatefulWidget {
  @override
  _AgregarTareaScreenState createState() => _AgregarTareaScreenState();
}

class _AgregarTareaScreenState extends State<AgregarTareaScreen> {
  final TextEditingController idMateriaController = TextEditingController();
  final TextEditingController fechaEntregaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController idTareaController = TextEditingController();

  List<Tarea> tareas = [];

  void _guardarTarea() async {
    final idMateria = int.tryParse(idMateriaController.text);
    final fechaEntrega = fechaEntregaController.text;
    final descripcion = descripcionController.text;

    if (idMateria != null && fechaEntrega.isNotEmpty && descripcion.isNotEmpty) {
      Tarea nuevaTarea = Tarea(
        idMateria: idMateria,
        fechaEntrega: fechaEntrega,
        descripcion: descripcion,
      );

      final id = await DBHelper.instance.insertTarea(nuevaTarea);

      if (id != null) {
        print("Tarea insertada con éxito");
        _limpiarCampos();
        _cargarTareas();
      } else {
        
      }
    } else {
     
    }
  }

  void _limpiarCampos() {
    idMateriaController.clear();
    fechaEntregaController.clear();
    descripcionController.clear();
    idTareaController.clear();
  }

  Future<void> _cargarTareas() async {
    final tareasList = await DBHelper.instance.getTareas();
    setState(() {
      tareas = tareasList;
    });
  }

 void _buscarTareaPorId() async {
  final id = idTareaController.text;

  if (id.isNotEmpty) {
    final tarea = await DBHelper.instance.getTareaById(int.parse(id));

    if (tarea != null) {
      idMateriaController.text = tarea.idMateria?.toString() ?? '';
      fechaEntregaController.text = tarea.fechaEntrega ?? '';
      descripcionController.text = tarea.descripcion ?? '';
    } else {
      // No se encontró ninguna tarea con el ID proporcionado
    }
  } else {
   
  }
}


  void _actualizarTarea() async {
    final idMateria = idMateriaController.text;
    final fechaEntrega = fechaEntregaController.text;
    final descripcion = descripcionController.text;
    final id = idTareaController.text;

    if (id.isNotEmpty &&
        idMateria.isNotEmpty &&
        fechaEntrega.isNotEmpty &&
        descripcion.isNotEmpty) {
      Tarea tareaActualizada = Tarea(
        id: int.parse(id),
        idMateria: int.parse(idMateria),
        fechaEntrega: fechaEntrega,
        descripcion: descripcion,
      );

      final rowsUpdated = await DBHelper.instance.updateTarea(tareaActualizada);

      if (rowsUpdated > 0) {
        print("Tarea actualizada con éxito");
        _limpiarCampos();
        _cargarTareas();
      } else {
       
      }
    } else {
     
    }
  }

  void _eliminarTareaPorId() async {
    final id = idTareaController.text;

    if (id.isNotEmpty) {
      final result = await DBHelper.instance.deleteTarea(int.parse(id));

      if (result != null) {
        print("Tarea eliminada con éxito");
        _limpiarCampos();
        _cargarTareas();
      } else {
     
      }
    } else {

    }
  }

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TAREAS'),
          backgroundColor: Colors.grey,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ver'),
              Tab(text: 'Nuevo'),
              Tab(text: 'Actualizar'),
              Tab(text: 'Eliminar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña "Ver"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  final tarea = tareas[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          'ID Materia: ${tarea.idMateria} - Fecha de Entrega: ${tarea.fechaEntrega}'),
                      subtitle: Text('ID Tarea: ${tarea.id} - Descripción: ${tarea.descripcion}'),
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
                    'Agregar Nueva Tarea',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Campo de entrada para el ID de la materia
                  TextField(
                    controller: idMateriaController,
                    decoration: InputDecoration(labelText: 'ID de la Materia'),
                  ),
                  Text(
                    'Formato yyyy-mm-dd',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Campo de entrada para la fecha de entrega
                  TextField(
                    controller: fechaEntregaController,
                    decoration: InputDecoration(labelText: 'Fecha de Entrega'),
                  ),
                  // Campo de entrada para la descripción
               
                  TextField(
                    controller: descripcionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                  // Botón para guardar la tarea
                  ElevatedButton(
                    onPressed: _guardarTarea,
                    child: Text('Crear Tarea'),
                  ),
                ],
              ),
            ),
            // Contenido de la pestaña "Actualizar"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Buscar Tarea Por ID',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Campo de entrada para buscar una tarea por ID
                  TextField(
                    controller: idTareaController,
                    decoration: InputDecoration(labelText: 'ID de la Tarea'),
                  ),
                  ElevatedButton(
                    onPressed: _buscarTareaPorId,
                    child: Text('Buscar Tarea por ID'),
                  ),
                  // Campos de entrada para actualizar la tarea
                  TextField(
                    controller: idMateriaController,
                    decoration: InputDecoration(labelText: 'ID de la Materia'),
                  ),
                   Text(
                    'Formato yyyy-mm-dd',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: fechaEntregaController,
                    decoration: InputDecoration(labelText: 'Fecha de Entrega'),
                  ),
                  TextField(
                    controller: descripcionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                  // Botón para actualizar la tarea
                  ElevatedButton(
                    onPressed: _actualizarTarea,
                    child: Text('Actualizar Tarea'),
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
                    'Eliminar Tarea Por ID',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Campo de entrada para eliminar una tarea por ID
                  TextField(
                    controller: idTareaController,
                    decoration: InputDecoration(
                        labelText: 'ID de la Tarea a Eliminar'),
                  ),
                  ElevatedButton(
                    onPressed: _eliminarTareaPorId,
                    child: Text('Eliminar Tarea por ID'),
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
