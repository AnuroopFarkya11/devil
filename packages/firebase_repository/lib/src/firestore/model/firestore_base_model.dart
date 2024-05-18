abstract class FireStoreBaseModel{
  Map<String,dynamic> toJson();
  FireStoreBaseModel fromJson();
  FireStoreBaseModel copyWith();
}