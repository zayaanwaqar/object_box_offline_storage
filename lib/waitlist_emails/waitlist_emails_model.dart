class WaitListEmails {
  Response? response;

  WaitListEmails({this.response});

  WaitListEmails.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
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
        results!.add(new Results.fromJson(v));
      });
    }
    count = json['count'];
    remaining = json['remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cursor'] = this.cursor;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['remaining'] = this.remaining;
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
    data['Modified Date'] = this.modifiedDate;
    data['Created Date'] = this.createdDate;
    data['Created By'] = this.createdBy;
    data['email'] = this.email;
    data['_id'] = this.sId;
    return data;
  }
}
