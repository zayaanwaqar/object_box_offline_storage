class WaitListEmails {
  Response? response;

  WaitListEmails({this.response});

  WaitListEmails.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  int? cursor;
  List<Results>? results;
  int? count;
  int? remaining;

  Response({this.cursor, this.results, this.count, this.remaining});

  Response.fromJson(Map<String, dynamic> json) {
    cursor = json['cursor'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    count = json['count'];
    remaining = json['remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cursor'] = cursor;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['remaining'] = remaining;
    return data;
  }
}

class Results {
  String? modifiedDate;
  String? createdDate;
  String? createdBy;
  String? email;
  String? sId;

  Results(
      {this.modifiedDate,
      this.createdDate,
      this.createdBy,
      this.email,
      this.sId});

  Results.fromJson(Map<String, dynamic> json) {
    modifiedDate = json['Modified Date'];
    createdDate = json['Created Date'];
    createdBy = json['Created By'];
    email = json['email'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Modified Date'] = modifiedDate;
    data['Created Date'] = createdDate;
    data['Created By'] = createdBy;
    data['email'] = email;
    data['_id'] = sId;
    return data;
  }
}
