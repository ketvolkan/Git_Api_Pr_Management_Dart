class PullRequestModel {
  String? url;
  int? id;
  int? number;
  String? state;
  String? title;

  PullRequestModel({this.url, this.id, this.number, this.state, this.title});

  PullRequestModel.fromJson(Map<String, dynamic> json) {
    url = json['url'] ?? "";
    id = json['id'] ?? 0;
    number = json['number'] ?? 0;
    state = json['state'] ?? "";
    title = json['title'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['id'] = id;
    data['number'] = number;
    data['state'] = state;
    data['title'] = title;
    return data;
  }
}
