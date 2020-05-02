import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

import 'direcciones_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scanBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('QR Scanner')
        ),
        actions: <Widget>[
          IconButton(
            icon : Icon(Icons.delete_forever),
            onPressed: scanBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _callpage(currentIndex),
      bottomNavigationBar: _crearBotonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scannQR( context ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus),
      ),
    );
  }

  _scannQR( context ) async {

    //geo:-20.232725607030616,-70.1360072179683
    
    String futureString ;

      try {
        futureString = await BarcodeScanner.scan();
      } catch( e ) {
        futureString = e.toString();
      }

    if( futureString !=null ) {

      final scan = ScanModel( valor: futureString );
      scanBloc.agregarScan(scan);

      if ( Platform.isIOS ) {
        
        Future.delayed( Duration( milliseconds:  750), () {
          utils.abrirScan(context, scan);
        });

      } else {
        utils.abrirScan(context, scan);
      }

    }

  }

  Widget _crearBotonNavigationBar(){

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapa')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ]
    );

  }

  Widget _callpage( int paginaActual ){

    switch(paginaActual) {

      case 0: return MapasPage();
      case 1: return DirecionesPage();

      default:
        return MapasPage();

    }

  }
}