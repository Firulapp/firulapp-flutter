class PetServiceItem {
  final String id;
  final int userId;
  final String category;
  final String title;
  final String address;
  final bool status;
  final String description;
  final String contact;
  final String email;
  final double price;

  const PetServiceItem({
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

  static const DUMMY_SERVICES = {
    "0": [
      {
        "dog": [
          PetServiceItem(
            id: "0",
            title: "",
            address: "",
            contact: "",
            description: "",
            email: "",
            price: 15000.00,
            userId: 1,
          ),
          PetServiceItem(
            id: "0",
            title: "Baño de perros",
            address: "",
            contact: "",
            description: "",
            email: "",
            price: 15000.00,
            userId: 1,
          )
        ]
      }
    ],
  };
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
  ];
}
