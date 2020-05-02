import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapCtrl = new MapController(); 

  String tipoMap = 'streets' ;

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapCtrl.move(scan.getLatLng(), 15);
            }
          )
        ],
      ),
      body: _crearMap(scan),
      floatingActionButton: _selectMap( context),
    );
  }

    Widget _selectMap( BuildContext context){

      return FloatingActionButton(
        onPressed: (){

          //streets, dark, lite, outdoors, satellite
          if ( tipoMap == 'streets' ){
            tipoMap = 'dark';
          }else if( tipoMap == 'dark' ){
            tipoMap = 'light';
          }else if ( tipoMap == 'light' ){
            tipoMap = 'outdoors';
          }else if ( tipoMap == 'outdoors' ){
            tipoMap = 'satellite';
          }else{
            tipoMap = 'streets';
          }
          setState((){});
          
        },
        child: Icon( Icons.repeat ),
        backgroundColor: Theme.of(context).primaryColor,
      );

    }

  Widget _crearMap(ScanModel scan) {

    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarca( scan )
      ],
    );

  }

  _crearMapa() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiamRyYXNoIiwiYSI6ImNrOHJ6NHRmOTA3cTAzbHF6aHE2b3kzMTgifQ.955DsYIfG_S-uAoZbvvGug',
        'id': 'mapbox.$tipoMap' 
        //streets, dark, lite, outdoors, satellite
      }
    );

  }

  _crearMarca(ScanModel scan) {

    return MarkerLayerOptions(

      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon(
              Icons.location_on,
              size: 60.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]

    );

  }
}