class Materia {
  int ?id;
  String ?nombre;
  String ?semestre;
  String ?docente;

  Materia({
    this.id,
    this.nombre,
    this.semestre,
    this.docente,
  });
  
  Materia.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
    semestre = map['semestre'];
    docente = map['docente'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'semestre': semestre,
      'docente': docente,
    };
  }
  
}