class CompanyModel {
  String id;
  String name;
  String branch;
  String city;
  String region;
  String? address;

  CompanyModel({
    required this.id,
    required this.name,
    required this.branch,
    required this.city,
    required this.region,
    required this.address
  });

  factory CompanyModel.fromJson(dynamic json) => CompanyModel(
    id: json["id"],
    name: json["name"],
    branch: json["branch"],
    city: json["city"],
    region: json["region"],
    address: json["address"],
  );
}