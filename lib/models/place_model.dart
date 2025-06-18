
class Place {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String address;
  final double rating;
  final String? imageUrl;
  final String? description;
  final List<String> amenities;
  final String? phoneNumber;
  final String? website;

  Place({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.rating,
    this.imageUrl,
    this.description,
    this.amenities = const [],
    this.phoneNumber,
    this.website,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      description: json['description'],
      amenities: List<String>.from(json['amenities'] ?? []),
      phoneNumber: json['phoneNumber'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'amenities': amenities,
      'phoneNumber': phoneNumber,
      'website': website,
    };
  }
}

// Dados mock para demonstração
class MockPlacesData {
  static List<Place> getMockPlaces() {
    return [
      // Academias
      Place(
        id: '1',
        name: 'Smart Fit',
        type: 'academia',
        latitude: -23.5505,
        longitude: -46.6333,
        address: 'Av. Paulista, 1000 - Bela Vista, São Paulo',
        rating: 4.2,
        description: 'Academia com equipamentos modernos e ambiente climatizado',
        amenities: ['Musculação', 'Cardio', 'Aulas em grupo', 'Vestiário'],
        phoneNumber: '(11) 3000-0000',
      ),
      Place(
        id: '2',
        name: 'Bio Ritmo',
        type: 'academia',
        latitude: -23.5515,
        longitude: -46.6343,
        address: 'R. Augusta, 500 - Consolação, São Paulo',
        rating: 4.5,
        description: 'Academia premium com personal trainers qualificados',
        amenities: ['Musculação', 'Pilates', 'Natação', 'Spa'],
        phoneNumber: '(11) 3000-0001',
      ),
      Place(
        id: '3',
        name: 'Academia Bodytech',
        type: 'academia',
        latitude: -23.5525,
        longitude: -46.6353,
        address: 'Av. Faria Lima, 2000 - Itaim Bibi, São Paulo',
        rating: 4.7,
        description: 'Rede de academias com tecnologia avançada',
        amenities: ['Musculação', 'Crossfit', 'Aulas funcionais', 'Nutricionista'],
        phoneNumber: '(11) 3000-0002',
      ),
      
      // Parques
      Place(
        id: '4',
        name: 'Parque Ibirapuera',
        type: 'parque',
        latitude: -23.5873,
        longitude: -46.6573,
        address: 'Av. Paulista, s/n - Vila Mariana, São Paulo',
        rating: 4.8,
        description: 'Maior parque urbano de São Paulo, ideal para corrida e caminhada',
        amenities: ['Pista de corrida', 'Ciclovia', 'Playground', 'Museus'],
      ),
      Place(
        id: '5',
        name: 'Parque Villa-Lobos',
        type: 'parque',
        latitude: -23.5447,
        longitude: -46.7197,
        address: 'Av. Prof. Fonseca Rodrigues, 2001 - Alto de Pinheiros',
        rating: 4.6,
        description: 'Parque com extensa área verde e atividades ao ar livre',
        amenities: ['Pista de corrida', 'Quadras esportivas', 'Playground', 'Biblioteca'],
      ),
      Place(
        id: '6',
        name: 'Parque do Carmo',
        type: 'parque',
        latitude: -23.6089,
        longitude: -46.4689,
        address: 'Av. Afonso de Sampaio e Sousa, 951 - Itaquera',
        rating: 4.3,
        description: 'Grande parque na zona leste com diversas atividades',
        amenities: ['Trilhas', 'Lago', 'Quadras', 'Área de piquenique'],
      ),
      
      // Trilhas
      Place(
        id: '7',
        name: 'Trilha do Pico do Jaraguá',
        type: 'trilha',
        latitude: -23.4556,
        longitude: -46.7661,
        address: 'Parque Estadual do Jaraguá - Pirituba, São Paulo',
        rating: 4.4,
        description: 'Trilha até o ponto mais alto da cidade de São Paulo',
        amenities: ['Vista panorâmica', 'Nível médio', 'Estacionamento'],
      ),
      Place(
        id: '8',
        name: 'Trilha da Pedra Grande',
        type: 'trilha',
        latitude: -23.4167,
        longitude: -46.6167,
        address: 'Parque Estadual da Cantareira - Tremembé',
        rating: 4.6,
        description: 'Trilha com vista espetacular da Grande São Paulo',
        amenities: ['Vista panorâmica', 'Nível fácil', 'Centro de visitantes'],
      ),
      Place(
        id: '9',
        name: 'Trilha do Morro do Elefante',
        type: 'trilha',
        latitude: -23.5167,
        longitude: -46.8167,
        address: 'Parque Nacional da Serra da Cantareira',
        rating: 4.2,
        description: 'Trilha desafiadora com recompensa visual incrível',
        amenities: ['Nível difícil', 'Cachoeira', 'Fauna diversa'],
      ),
    ];
  }

  static List<Place> getPlacesByType(String type) {
    return getMockPlaces().where((place) => place.type == type).toList();
  }

  static List<Place> getNearbyPlaces(double lat, double lon, double radiusKm) {
    // Simulação simples de proximidade
    return getMockPlaces().where((place) {
      double distance = _calculateDistance(lat, lon, place.latitude, place.longitude);
      return distance <= radiusKm;
    }).toList();
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Fórmula simplificada para demonstração
    double deltaLat = lat2 - lat1;
    double deltaLon = lon2 - lon1;
    return (deltaLat * deltaLat + deltaLon * deltaLon) * 111; // Aproximação em km
  }
}
