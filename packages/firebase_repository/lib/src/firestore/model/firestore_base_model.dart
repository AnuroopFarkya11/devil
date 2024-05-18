abstract class FireStoreBaseModel{
  Map<String, dynamic> toJson();
  FireStoreBaseModel fromJson(Map<String, dynamic> json);
  FireStoreBaseModel copyWith(Map<String, dynamic> updates);
}