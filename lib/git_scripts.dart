// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:process_run/process_run.dart';

import 'pull_request_model.dart';

void main() async {
  String baseUrl = "https://api.github.com/repos/YOUR_GITHUB_NAME/YOUR_GITHUB_REPO/pulls";
  var token = "YOUR_GITHUB_TOKEN";
  var headers = {"Accept": "application/vnd.github+json", "Authorization": "Bearer $token", "X-GitHub-Api-Version": "2022-11-28"};
  if (await mergePullRequest(headers, (await createPullRequest(headers, baseUrl)), baseUrl)) {
    print("Completed!");
    gitPullAllBranches();
  } else {
    print("Error");
  }
}

//*Creating Pr's
Future<Map<App, PullRequestModel>> createPullRequest(headers, String baseUrl) async {
  Map<App, PullRequestModel> pullRequest = {};
  var url = Uri.parse(baseUrl);
  //*For for all branches
  for (var app in App.values) {
    var data = {"title": "Main Changes Get", "body": "Main Changes Get", "head": "main", "base": app.branch};
    var response = await http.post(url, headers: headers, body: json.encode(data));
    if (response.statusCode == 201) {
      pullRequest[app] = PullRequestModel.fromJson(jsonDecode(response.body));
      print("Pull request created successfully. -${app.name}");
    } else {
      print("Error creating pull request: ${response.reasonPhrase} -${app.name}");
    }
  }
  return pullRequest;
}

Future<void> gitPullAllBranches() async {
  var shell = Shell();
  for (var app in App.values) {
    await shell.run("git checkout ${app.branch}");
    await shell.run("git pull");
  }
  await shell.run("git checkout main");
}

//*Merging Pr's
Future<bool> mergePullRequest(headers, Map<App, PullRequestModel> pullRequest, String baseUrl) async {
  bool isSuccess = true;
  //*For for all branches
  for (var app in App.values) {
    if (pullRequest[app] == null) continue;
    if (pullRequest[app]?.number == 0) continue;
    var url = Uri.parse("$baseUrl/${pullRequest[app]?.number}/merge");
    print(url.toString());
    var data = {"commit_title": "Merge Confirm", "commit_message": "Merge confirmed with api"};
    var response = await http.put(url, headers: headers, body: json.encode(data));
    if (response.statusCode == 200) {
      pullRequest[app] = PullRequestModel.fromJson(jsonDecode(response.body));
      print("Pull request merged successfully. -${app.name}");
    } else {
      print("Error merged pull request: ${response.reasonPhrase} -${app.name}");
      isSuccess = false;
    }
  }
  return isSuccess;
}

//* For Your Branches { branch1, branch2, branch3, branch4 ,....}
enum App {
  branch1,
  branch2,
  branch3,
  branch4;

  String get branch {
    switch (this) {
      case App.branch1:
        return "branch1_name";
      case App.branch2:
        return "branch2_name";
      case App.branch3:
        return "branch3_name";
      case App.branch4:
        return "branch4_name";
      default:
        return "branch1_name";
    }
  }
}
