// ignore: camel_case_types
class pfpsWallpaper {
  String? totalPost;
  String? totalPage;
  List<List<Data>>? data;

  pfpsWallpaper({this.totalPost, this.totalPage, this.data});
  pfpsWallpaper.fromJson(Map<String, dynamic> json) {
    totalPost = json['total_post'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = <List<Data>>[];
      json['data'].forEach((v) {
        if (v is List) {
          List<Data> dataList = [];
          for (var item in v) {
            dataList.add(Data.fromJson(item));
          }
          data!.add(dataList);
        }
      });
    }
  }
}

class Data {
  String? id;
  String? title;
  String? catname;
  String? url;
  // ignore: non_constant_identifier_names
  String? file_high;
  String? size;
  String? views;
  Data(
      {this.id,
      this.title,
      this.catname,
      this.url,
      // ignore: non_constant_identifier_names
      this.file_high,
      this.size,
      this.views}); // Include the new property in the constructor

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    catname = json['catname'];
    url = json['url'];
    file_high = json['file_high'];
    size = json['size'];
    views = json['views'];
    // Assign the value from JSON to the new property
  }
}
