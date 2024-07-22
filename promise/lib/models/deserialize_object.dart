abstract class DeserializeObject {
  T fromJson<T>(Map<String, dynamic> json);
  Map<String, dynamic> toJson<T>(T t);
}