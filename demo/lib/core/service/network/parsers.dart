abstract interface class JsonParser<T> {
  T parse(Map<String,dynamic> json);

}