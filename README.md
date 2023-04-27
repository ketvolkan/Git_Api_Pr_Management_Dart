
# Git Pr Management

Github maini çoklu branch'e pr atma ve onaylama komutu
## Creating Pr's


```dart
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
```
## Merging Pr's
```dart

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

```
## Your Brancs Enum
Dilediğiniz kadar branch'i tanımlayabilirsiniz
```dart

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

```
  ## Run
```dart
dart run git_scripts.dart
```
## Github Api Key

Github hesabınız üzerinden repolarınıza erişiminiz olduğu bir token oluşturmanız gerekiyor

`var token = "YOUR_GITHUB_TOKEN";` ve oluşturduğunuz keyi burada kullanın


  
## Creator

- [@smhoz](https://www.github.com/smhoz)
- [@ketvolkan](https://www.github.com/ketvolkan)

  


  
