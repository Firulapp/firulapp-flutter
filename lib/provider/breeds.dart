class Breeds {
  int breed;

  static final Map<int, String> map = {
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
  };

  String get breedString {
    return (map.containsKey(breed) ? map[breed] : "unknown");
  }

  Breeds(this.breed);

  String toString() {
    return ("$breed $breedString");
  }

  static List<Breeds> get list {
    return (map.keys.map((num) {
      return (Breeds(num));
    })).toList();
  }
}
