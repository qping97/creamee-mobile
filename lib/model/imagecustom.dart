class ImageCustom {
  String url;
  ImageCustom({
    this.url,
  });
  ImageCustom.fromJson(String json) {
    url = "http://192.168.0.187:8000/" + json;
  }
}
