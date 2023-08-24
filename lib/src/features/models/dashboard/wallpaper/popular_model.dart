import 'package:loonaz_application/src/constants/image_strings.dart';

class PopularModelClass {
  int id;
  String imageUrl;

  PopularModelClass(this.id, this.imageUrl);
    static List<PopularModelClass> list = [
      PopularModelClass(1, img1),
      PopularModelClass( 2,  img2),
      PopularModelClass( 3,  img3),
      PopularModelClass( 4,  img4),
      PopularModelClass( 5,  img5),
      PopularModelClass( 6,  img6),
      PopularModelClass( 6,  img1),
      PopularModelClass( 6,  img2),
      PopularModelClass( 6,  img3)
    ];
  // factory CategoryModelClass.fromJson(Map<String, dynamic> json) {
  //   return CategoryModelClass(
  //     id: json['categoryid'],
  //     categoryname: json['categoryname'],
  //     categoryurl: json['categoryurl'],
  //   );
  // }
}
