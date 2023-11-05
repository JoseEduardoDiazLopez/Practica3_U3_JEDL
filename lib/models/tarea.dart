class Tarea {
  int? id;
  int? idMateria;
  String? fechaEntrega;
  String? descripcion;

  Tarea({
    this.id,
    this.idMateria,
    this.fechaEntrega,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idMateria': idMateria,
      'fechaEntrega': fechaEntrega,
      'descripcion': descripcion,
    };
  }

  Tarea.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idMateria = map['idMateria'];
    fechaEntrega = map['fechaEntrega'];
    descripcion = map['descripcion'];
  }
}
