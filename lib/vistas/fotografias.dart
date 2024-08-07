import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CarpetaFotos {
  final String nombre;
  final List<File> fotos;

  CarpetaFotos(this.nombre) : fotos = [];
}

class Fotos extends StatefulWidget {
  const Fotos({super.key});

  @override
  _GaleriaState createState() => _GaleriaState();
}

class _GaleriaState extends State<Fotos> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, CarpetaFotos> _carpetas = {};

  Future<void> _tomarFoto(String nombreCarpeta) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        final carpeta = _carpetas.putIfAbsent(
          nombreCarpeta,
              () => CarpetaFotos(nombreCarpeta),
        );
        carpeta.fotos.add(File(pickedFile.path));
      });
    }
  }

  void _crearCarpeta() {
    final TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Nueva Carpeta'),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre de la Carpeta'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nombreCarpeta = nombreController.text;
                if (nombreCarpeta.isNotEmpty && !_carpetas.containsKey(nombreCarpeta)) {
                  setState(() {
                    _carpetas[nombreCarpeta] = CarpetaFotos(nombreCarpeta);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Crear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarFotos(CarpetaFotos carpeta) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(carpeta.nombre),
          content: SingleChildScrollView(
            child: Column(
              children: carpeta.fotos.isEmpty
                  ? [const Text('No hay fotos en esta carpeta.')]
                  : carpeta.fotos.map((foto) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Image.file(foto),
              )).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Fotos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _carpetas.length,
              itemBuilder: (context, index) {
                final nombreCarpeta = _carpetas.keys.elementAt(index);
                final carpeta = _carpetas[nombreCarpeta]!;

                return ListTile(
                  title: Text(carpeta.nombre),
                  trailing: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _tomarFoto(carpeta.nombre),
                  ),
                  onTap: () => _mostrarFotos(carpeta),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _crearCarpeta,
              child: const Text('Crear Nueva Carpeta'),
            ),
          ),
        ],
      ),
    );
  }
}
