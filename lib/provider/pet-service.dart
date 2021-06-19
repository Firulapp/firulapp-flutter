class PetServiceItem {
  final String id;
  final String title;
  final String icon;

  const PetServiceItem({this.id, this.title, this.icon});
}

const DUMMY_SERVICES = const [
  PetServiceItem(
    id: '1',
    title: 'Baño',
    icon: 'assets/icons/dog-shower.svg',
  ),
  PetServiceItem(
    id: '2',
    title: 'Paseo',
    icon: 'assets/icons/dog-walking.svg',
  ),
  PetServiceItem(
    id: '3',
    title: 'Tienda',
    icon: 'assets/icons/pet-shop.svg',
  ),
  PetServiceItem(
    id: '4',
    title: 'Entrenamiento',
    icon: 'assets/icons/dog-train.svg',
  ),
  PetServiceItem(
    id: '5',
    title: 'Veterinaria',
    icon: 'assets/icons/vet.svg',
  ),
];
