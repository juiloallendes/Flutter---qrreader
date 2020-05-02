import 'dart:async';

import 'package:qrreaderapp/src/models/scan_model.dart';

class Validator {

//Se creará el primer StreamTranformer 
final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
  handleData: ( scans, sink ) {

    //SI scans (s) en igual a geo, se hace el sink.add
    final geoScans = scans.where( (s) => s.tipo == 'geo').toList();
    //Se agrega el scan de tipo geo
    sink.add(geoScans);

  }
);

//Se creará el segundo StreamTranformer 
final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
  handleData: ( scans, sink ) {

    //SI scans (s) en igual a http, se hace el sink.add
    final geoScans = scans.where( (s) => s.tipo == 'http').toList();
    //Se agrega el scan de tipo http
    sink.add(geoScans);

  }
);


}