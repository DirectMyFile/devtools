part of devtools.tool.screenshot;

void execute(List<String> args) {
  for (int i = 5; i >= 1; i--) {
    print(i);
    sleep(new Duration(seconds: 1));
  }
  
  var file = new File("/tmp/screenshot.png");
  
  if (file.existsSync()) file.deleteSync();
  
  var result = Process.runSync("scrot", [file.absolute.path]);
  
  if (result.exitCode != 0) {
    print("ERROR: 'scrot ${file.absolute.path}' exited with status ${result.exitCode}");
    exit(1);
  }
  
  /* TODO: Make this have the time the screenshot was taken */
  var title = "Screenshot";
  
  var image = CryptoUtils.bytesToBase64(file.readAsBytesSync());
  
  var body = { "image": image, "title": title };
  
  var headers = {
    "Authorization": "Client-ID 9980475589b7ca3"
  };
  
  http.post("https://api.imgur.com/3/image", body: body, headers: headers).then((response) {
    if (response.statusCode == 200) {
      var json = JSON.decode(response.body);
      Clipboard.setClipboard(json['data']['link']);
    } else {
      print("ERROR: Failed to upload to Imgur! Status Code: ${response.statusCode}");
      exit(1);
    }
  });
}