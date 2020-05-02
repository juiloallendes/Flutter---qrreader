import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validator{

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //Obtener Scans de la Base de datos
    obtenerScans();

  }

  //Flujo de datos
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);

  // Se aplicará el llamdo pero con filtro para web
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  //AGREGAR SCAN 
  agregarScan (ScanModel scan) async {

    await DBProvider.db.nuevoScan(scan);
    obtenerScans();

  }

  //OBTENER scans
  obtenerScans() async {

    _scansController.sink.add( await DBProvider.db.getTodosScans() );

  }

  //BORRAR scan
  borrarScan(int id) async {

    await DBProvider.db.deleteScan(id);
    obtenerScans();

  }

  borrarScanTODOS() async {

    await DBProvider.db.deleteScanAll();
    obtenerScans();

  }

}

//final scanBLoc = new ScansBloc();