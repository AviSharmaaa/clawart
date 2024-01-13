class AppAssets {
  static final images = _Images();
  static final animations = _Animations();
  static final icons = _Icons();
}

class _Images {
  static const path = 'assets/images';
  final pawcasso = '$path/pawcasso.png';
  final background = '$path/background.png';
  final circle = '$path/circle.png';
  final square = '$path/square.png';
  final triangle = '$path/triangle.png';
  final avatar = '$path/avatar.png';
}

class _Animations {
  static const path = 'assets/animations';
  final cat = '$path/cat.riv';
  final shapes = '$path/shapes.riv';
  final loader = '$path/loader.riv';
  final easterEgg = '$path/easter_egg.riv';
}

class _Icons {
  static const path = 'assets/icons';
  final selectAll = '$path/select_all.svg';
  final delete = '$path/delete.svg';
  final loader = '$path/loader.svg';
  final placeholder = '$path/placeholder.svg';
}
