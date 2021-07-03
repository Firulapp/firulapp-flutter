class ServiceType {
  final int id;
  final String title;
  final String icon;

  const ServiceType({this.id, this.title, this.icon});

  static const DUMMY_CATEGORIES = const [
    ServiceType(
      id: 1,
      title: 'Baño',
      icon: 'assets/icons/dog-shower.svg',
    ),
    ServiceType(
      id: 2,
      title: 'Paseo',
      icon: 'assets/icons/dog-walking.svg',
    ),
    ServiceType(
      id: 3,
      title: 'Tienda',
      icon: 'assets/icons/pet-shop.svg',
    ),
    ServiceType(
      id: 4,
      title: 'Entrenamiento',
      icon: 'assets/icons/dog-train.svg',
    ),
    ServiceType(
      id: 5,
      title: 'Veterinaria',
      icon: 'assets/icons/vet.svg',
    ),
    ServiceType(
      id: 0,
      title: 'Mis Servicios',
      icon: 'assets/icons/businessman.svg',
    ),
  ];
}
