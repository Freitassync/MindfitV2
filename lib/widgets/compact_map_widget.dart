import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/location_provider.dart';
import 'package:smart_has_app/models/place_model.dart';
import 'package:smart_has_app/screens/map_screen.dart';

class CompactMapWidget extends StatefulWidget {
  const CompactMapWidget({super.key});

  @override
  State<CompactMapWidget> createState() => _CompactMapWidgetState();
}

class _CompactMapWidgetState extends State<CompactMapWidget> {
  Set<Marker> _markers = {};
  List<Place> _nearbyPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyPlaces();
  }

  void _loadNearbyPlaces() {
    // Carrega apenas os 3 locais mais próximos para o widget compacto
    final allPlaces = MockPlacesData.getMockPlaces();
    _nearbyPlaces = allPlaces.take(3).toList();

    _markers.clear();
    for (Place place in _nearbyPlaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${place.rating}⭐',
          ),
          icon: _getMarkerIcon(place.type),
        ),
      );
    }

    if (mounted) setState(() {});
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case 'academia':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'parque':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'trilha':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'academia':
        return Icons.fitness_center;
      case 'parque':
        return Icons.park;
      case 'trilha':
        return Icons.hiking;
      default:
        return Icons.place;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'academia':
        return Colors.red;
      case 'parque':
        return Colors.green;
      case 'trilha':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Locais Próximos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
                  child: const Text("Ver todos"),
                ),
              ],
            ),
          ),
          // Mapa compacto
          Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: locationProvider.currentPosition != null
                          ? LatLng(
                              locationProvider.currentPosition!.latitude,
                              locationProvider.currentPosition!.longitude,
                            )
                          : const LatLng(
                              -23.5505, -46.6333), // São Paulo como padrão
                      zoom: 13,
                    ),
                    markers: _markers,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    onTap: (_) {
                      // Ao tocar no mapa, abre a tela completa
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MapScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Lista de locais próximos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: _nearbyPlaces
                  .map((place) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    _getTypeColor(place.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getTypeIcon(place.type),
                                color: _getTypeColor(place.type),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        place.rating.toString(),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          place.address,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                              size: 16,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
