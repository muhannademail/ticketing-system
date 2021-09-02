import 'CompanyModel.dart';

class TicketModel {
  String  id;
  String? title;
  int     type;
  int     urgency;
  String  description;
  String? fileUrl;
  int     status; // 0:Pending - 1:Resolved
  String  issuerId;
  String  issuerName;
  String  companyId;
  String  companyName;
  String  created;
  String?  technicianGrade;
  String?  assignment;

  TicketModel({
    required this.id,
    required this.title,
    required this.type,
    required this.urgency,
    required this.description,
    required this.fileUrl,
    required this.status,
    required this.issuerId,
    required this.issuerName,
    required this.companyId,
    required this.companyName,
    required this.created,
    required this.technicianGrade,
    required this.assignment,
  });

  factory TicketModel.fromJson(dynamic json) => TicketModel(
    id:           json["id"],
    title:        json["title"],
    type:         json["type"],
    urgency:      json["urgency"],
    description:  json["description"],
    fileUrl:      json["fileUrl"],
    status:       json["status"],
    issuerId:     json["issuerId"],
    issuerName:       json["issuerName"],
    companyId:        json["companyId"],
    companyName:      json["companyName"],
    created:          json["created"],
    technicianGrade:  json["technicanGrade"],
    assignment:       json["assignment"],
  );
}