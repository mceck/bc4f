class ImageElement {
  String src;
  int width, height;
  ImageElement({this.src, this.height, this.width, style});
  void setAttribute(name, value) {}
}

class CssStyleDeclaration {
  factory CssStyleDeclaration.css(String css) => null;
}
