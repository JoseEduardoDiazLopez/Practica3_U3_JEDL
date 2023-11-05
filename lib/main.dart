import 'package:flutter/material.dart';
import 'package:dam_u3_practica1/pantallas/tarea_screen.dart';
import 'package:dam_u3_practica1/pantallas/materia_screen.dart';
import 'package:dam_u3_practica1/pantallas/agenda_screen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    AgendaScreen(),
    AgregarMateriaScreen(),
    AgregarTareaScreen(),
 
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
              BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Tablero',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Materias',
            ),
              BottomNavigationBarItem(
              icon: Icon(Icons.list), 
              label: 'Tareas', 
            ),
          
            
          
          ],
        ),
      ),
    );
  }
}
