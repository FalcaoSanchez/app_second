import 'package:flutter/material.dart';

class Contacto {
  final String nombre;
  final String telefono;
  final String clinica;
  final String? direccion;

  Contacto(this.nombre, this.telefono, this.clinica, [this.direccion]);
}

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  final List<Contacto> _contactos = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _clinicaController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  void _agregarContacto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Contacto'),
          content: SizedBox(
            width: 300, // Ajusta el ancho del diálogo si es necesario
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: _telefonoController,
                    decoration: InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: _clinicaController,
                    decoration: InputDecoration(labelText: 'Clínica'),
                  ),
                  TextField(
                    controller: _direccionController,
                    decoration: InputDecoration(labelText: 'Dirección (opcional)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nombre = _nombreController.text;
                final telefono = _telefonoController.text;
                final clinica = _clinicaController.text;
                final direccion = _direccionController.text;

                if (nombre.isNotEmpty && telefono.isNotEmpty && clinica.isNotEmpty) {
                  setState(() {
                    _contactos.add(Contacto(nombre, telefono, clinica, direccion.isEmpty ? null : direccion));
                  });

                  _nombreController.clear();
                  _telefonoController.clear();
                  _clinicaController.clear();
                  _direccionController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                _nombreController.clear();
                _telefonoController.clear();
                _clinicaController.clear();
                _direccionController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetallesContacto(Contacto contacto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contacto.nombre),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 400, // Altura máxima del diálogo
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Teléfono: ${contacto.telefono}', style: TextStyle(fontSize: 16)),
                  Text('Clínica: ${contacto.clinica}', style: TextStyle(fontSize: 16)),
                  if (contacto.direccion != null) Text('Dirección: ${contacto.direccion}', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _borrarContacto(int index) {
    setState(() {
      _contactos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contactos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _contactos.length,
              itemBuilder: (context, index) {
                final contacto = _contactos[index];

                return ListTile(
                  title: Text(contacto.nombre),
                  onTap: () => _mostrarDetallesContacto(contacto),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _borrarContacto(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agregarContacto,
                child: Text('Agregar Contacto'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
