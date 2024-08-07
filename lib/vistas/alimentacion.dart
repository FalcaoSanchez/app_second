import 'package:flutter/material.dart';

class HorarioAlimentacion {
  final String tipoComida;
  final double cantidad;
  final int intervaloHoras;

  HorarioAlimentacion(this.tipoComida, this.cantidad, this.intervaloHoras);
}

class Alimentacion extends StatefulWidget {
  const Alimentacion({super.key});

  @override
  _AlimentacionState createState() => _AlimentacionState();
}

class _AlimentacionState extends State<Alimentacion> {
  final List<HorarioAlimentacion> _horarios = [];
  final TextEditingController _tipoComidaController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _intervaloHorasController = TextEditingController();

  void _agregarHorario() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Horario de Alimentación'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _tipoComidaController,
                  label: 'Tipo de Comida',
                ),
                _buildTextField(
                  controller: _cantidadController,
                  label: 'Cantidad (gramos)',
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: _intervaloHorasController,
                  label: 'Intervalo (horas)',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: _handleAgregarHorario,
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: _handleCancelar,
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
  }

  void _handleAgregarHorario() {
    final tipoComida = _tipoComidaController.text;
    final cantidad = double.tryParse(_cantidadController.text);
    final intervaloHoras = int.tryParse(_intervaloHorasController.text);

    if (tipoComida.isNotEmpty && cantidad != null && intervaloHoras != null) {
      setState(() {
        _horarios.add(HorarioAlimentacion(tipoComida, cantidad, intervaloHoras));
      });
      _clearTextControllers();
      Navigator.of(context).pop();
    }
  }

  void _handleCancelar() {
    _clearTextControllers();
    Navigator.of(context).pop();
  }

  void _clearTextControllers() {
    _tipoComidaController.clear();
    _cantidadController.clear();
    _intervaloHorasController.clear();
  }

  void _mostrarDetallesHorario(HorarioAlimentacion horario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles del Horario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo de Comida: ${horario.tipoComida}'),
                Text('Cantidad: ${horario.cantidad} gramos'),
                Text('Intervalo: cada ${horario.intervaloHoras} horas'),
              ],
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

  void _borrarHorario(int index) {
    setState(() {
      _horarios.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horarios de Alimentación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _horarios.length,
              itemBuilder: (context, index) {
                final horario = _horarios[index];

                return ListTile(
                  title: Text(horario.tipoComida),
                  subtitle: Text(
                    'Cantidad: ${horario.cantidad}g, Cada ${horario.intervaloHoras} horas',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _borrarHorario(index),
                  ),
                  onTap: () => _mostrarDetallesHorario(horario),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _agregarHorario,
              child: const Text('Agregar Horario de Alimentación'),
            ),
          ),
        ],
      ),
    );
  }
}
