import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Recordatorio {
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final TimeOfDay hora;

  Recordatorio(this.titulo, this.descripcion, this.fecha, this.hora);
}

class RecordatoriosPage extends StatefulWidget {
  const RecordatoriosPage({super.key});

  @override
  _RecordatoriosPageState createState() => _RecordatoriosPageState();
}

class _RecordatoriosPageState extends State<RecordatoriosPage> {
  final List<Recordatorio> _recordatorios = [];
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  final Set<int> _recordatoriosSeleccionados = {};
  bool _modoSeleccion = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _agregarRecordatorio() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Recordatorio'),
          content: _buildAgregarRecordatorioDialogContent(),
          actions: _buildDialogActions(),
        );
      },
    );
  }

  Column _buildAgregarRecordatorioDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _tituloController,
          decoration: const InputDecoration(labelText: 'Evento'),
        ),
        TextField(
          controller: _descripcionController,
          decoration: const InputDecoration(labelText: 'Descripción'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _seleccionarFecha(context),
                child: Text(
                  _fechaSeleccionada == null
                      ? 'Seleccionar Fecha'
                      : DateFormat('dd/MM/yyyy').format(_fechaSeleccionada!),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: () => _seleccionarHora(context),
                child: Text(
                  _horaSeleccionada == null
                      ? 'Seleccionar Hora'
                      : _horaSeleccionada!.format(context),
                ),
              ),
            ),
          ],
        ),
        if (_fechaSeleccionada != null && _horaSeleccionada != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Fecha y Hora Seleccionadas: ${DateFormat('dd/MM/yyyy').format(_fechaSeleccionada!)} ${_horaSeleccionada!.format(context)}',
            ),
          ),
      ],
    );
  }

  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed: () {
          final titulo = _tituloController.text;
          final descripcion = _descripcionController.text;
          final fecha = _fechaSeleccionada;
          final hora = _horaSeleccionada;

          if (titulo.isNotEmpty && descripcion.isNotEmpty && fecha != null && hora != null) {
            setState(() {
              _recordatorios.add(Recordatorio(titulo, descripcion, fecha, hora));
            });

            _tituloController.clear();
            _descripcionController.clear();
            _fechaSeleccionada = null;
            _horaSeleccionada = null;
            Navigator.of(context).pop();
          }
        },
        child: const Text('Agregar'),
      ),
      TextButton(
        onPressed: () {
          _tituloController.clear();
          _descripcionController.clear();
          _fechaSeleccionada = null;
          _horaSeleccionada = null;
          Navigator.of(context).pop();
        },
        child: const Text('Cancelar'),
      ),
    ];
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaSeleccionada = fechaSeleccionada;
      });
    }
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.now(),
    );
    if (horaSeleccionada != null) {
      setState(() {
        _horaSeleccionada = horaSeleccionada;
      });
    }
  }

  void _mostrarDetallesRecordatorio(Recordatorio recordatorio) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(recordatorio.titulo),
          content: _buildDetallesRecordatorioDialogContent(recordatorio),
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

  Column _buildDetallesRecordatorioDialogContent(Recordatorio recordatorio) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripción: ${recordatorio.descripcion}'),
        Text('Fecha: ${DateFormat('dd/MM/yyyy').format(recordatorio.fecha)}'),
        Text('Hora: ${recordatorio.hora.format(context)}'),
      ],
    );
  }

  void _toggleModoSeleccion() {
    setState(() {
      _modoSeleccion = !_modoSeleccion;
      if (!_modoSeleccion) {
        _recordatoriosSeleccionados.clear();
      }
    });
  }

  void _borrarRecordatoriosSeleccionados() {
    setState(() {
      _recordatorios.removeWhere((recordatorio) =>
          _recordatoriosSeleccionados.contains(_recordatorios.indexOf(recordatorio)));
      _recordatoriosSeleccionados.clear();
      _modoSeleccion = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Recordatorios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _recordatorios.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final recordatorio = _recordatorios[index];
                final estaSeleccionado = _recordatoriosSeleccionados.contains(index);

                return ListTile(
                  title: Text(recordatorio.titulo),
                  trailing: _modoSeleccion
                      ? (estaSeleccionado ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank))
                      : null,
                  onTap: () {
                    if (_modoSeleccion) {
                      setState(() {
                        if (estaSeleccionado) {
                          _recordatoriosSeleccionados.remove(index);
                        } else {
                          _recordatoriosSeleccionados.add(index);
                        }
                      });
                    } else {
                      _mostrarDetallesRecordatorio(recordatorio);
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      _modoSeleccion = true;
                      _recordatoriosSeleccionados.add(index);
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _agregarRecordatorio,
                  child: const Text('Agregar Recordatorio'),
                ),
                ElevatedButton(
                  onPressed: _modoSeleccion ? _borrarRecordatoriosSeleccionados : _toggleModoSeleccion,
                  child: Text(_modoSeleccion ? 'Borrar Seleccionados' : 'Seleccionar para Borrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
