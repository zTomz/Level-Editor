import 'dart:convert';
import 'dart:io';

// ignore: camel_case_types
class jsonWorker {
  static void saveJSON(String directory, Map jsonData) {

    File jsonFile = File(directory);
    jsonFile.writeAsString(json.encode(jsonData));
  }

  static Future<Map> loadJSON(String directory) async {
    late File jsonFile;

    try {
      jsonFile = File(directory);
    } catch (e) {
      return {
        "Error": e.toString(),
      };
    }

    Map data = json.decode(await jsonFile.readAsString());

    return data;
  }
}
