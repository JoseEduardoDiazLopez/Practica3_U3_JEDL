import 'package:flutter/material.dart';
import 'package:dam_u3_practica1/models/tarea.dart';
import 'package:dam_u3_practica1/database/db_helper.dart';
import 'package:intl/intl.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<Tarea> tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    final tareasList = await DBHelper.instance.getTareas();
    setState(() {
      tareas = tareasList;
    });
  }

  Future<String> _getNombreMateria(int idMateria) async {
    final materia = await DBHelper.instance.getMateriaById(idMateria);
    return materia?.nombre ?? 'Materia no disponible';
  }

  Widget _buildSection(String title, List<Tarea> tareas) {
    Color backgroundColor;
    if (title == "Hoy") {
      backgroundColor = Colors.yellow; // Amarillo para las tareas de hoy
    } else if (title == "Vencidas") {
      backgroundColor = Colors.red; // Rojo para las tareas vencidas
    } else {
      backgroundColor = Colors.white; // Blanco para las tareas pendientes
    }

    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        for (final tarea in tareas) 
  if ((title == "Hoy" && tarea.fechaEntrega == DateFormat('yyyy-MM-dd').format(now)) ||
      (title == "Vencidas" &&
          (tarea.fechaEntrega != null &&
              tarea.fechaEntrega!.compareTo(DateFormat('yyyy-MM-dd').format(now)) < 0)) ||
      (title == "Pendientes" &&
          (tarea.fechaEntrega != null &&
              tarea.fechaEntrega!.compareTo(DateFormat('yyyy-MM-dd').format(now)) > 0)))

            FutureBuilder<String>(
              future: _getNombreMateria(tarea.idMateria!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final materiaNombre = snapshot.data ?? 'Materia no disponible';
                  return Card(
                    color: backgroundColor, // Establece el color de fondo según el estado
                    child: ListTile(
                      title: Text(tarea.descripcion ?? 'Descripción no disponible'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha de Entrega: ${tarea.fechaEntrega}'),
                          Text('Materia: $materiaNombre'),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Muestra un indicador de carga mientras se obtiene el nombre de la materia
                  return CircularProgressIndicator();
                }
              },
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tablero'),
        backgroundColor: Colors.grey,
      ),
      body: ListView(
        children: [
          _buildSection("Hoy", tareas),
          _buildSection("Vencidas", tareas),
          _buildSection("Pendientes", tareas),
        ],
      ),
    );
  }
}
