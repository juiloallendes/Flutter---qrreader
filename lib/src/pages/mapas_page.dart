import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {

  final scansBLoc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    //despues de dibujar, se llama al streamController
    scansBLoc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBLoc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {

        if( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator(),);
        }

        final scans = snapshot.data;

        if ( scans.length == 0 ) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: ( contex, i) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.grey
            ),
            onDismissed: ( direction ) => scansBLoc.borrarScan(scans[i].id),
            child: ListTile(
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
              title: Text( scans[i].valor ),
              subtitle: Text('ID: ${ scans[i].id }'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.abrirScan(context,scans[i]),
            ),
          )
          
        );


      },
    );
  }
}