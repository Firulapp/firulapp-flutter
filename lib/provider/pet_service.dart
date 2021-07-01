class PetServiceItem {
  String id;
  int userId;
  String category;
  String title;
  String address;
  bool status;
  String description;
  String contact;
  String email;
  double price;

  PetServiceItem({
    this.id,
    this.userId,
    this.category,
    this.title,
    this.address,
    this.description,
    this.contact,
    this.email,
    this.status,
    this.price,
  });
}

class CategoryItem {
  final String id;
  final String title;
  final String icon;

  const CategoryItem({this.id, this.title, this.icon});

  static const DUMMY_CATEGORIES = const [
    CategoryItem(
      id: '1',
      title: 'Baño',
      icon: 'assets/icons/dog-shower.svg',
    ),
    CategoryItem(
      id: '2',
      title: 'Paseo',
      icon: 'assets/icons/dog-walking.svg',
    ),
    CategoryItem(
      id: '3',
      title: 'Tienda',
      icon: 'assets/icons/pet-shop.svg',
    ),
    CategoryItem(
      id: '4',
      title: 'Entrenamiento',
      icon: 'assets/icons/dog-train.svg',
    ),
    CategoryItem(
      id: '5',
      title: 'Veterinaria',
      icon: 'assets/icons/vet.svg',
    ),
    CategoryItem(
      id: '0',
      title: 'Mis Servicios',
      icon: 'assets/icons/businessman.svg',
    ),
  ];
}
