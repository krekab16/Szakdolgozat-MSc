import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/map_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          map,
          style: Styles.textStyles,
        ),
      ),
      body: Stack(
        children: [
          if (mapViewModel.errorMessages.isNotEmpty)...[
            Text(mapViewModel.errorMessages.join(' ')),
          ] else...[
            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: mapViewModel.onMapCreated,
              initialCameraPosition: mapViewModel.initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: mapViewModel.getCurrentMarker(),
            ),
          ],
        ],
      ),
    );
  }
}
