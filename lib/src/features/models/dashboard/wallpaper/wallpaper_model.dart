class WallpaperModelClass {
  int id;
  String imageUrl;
  String title;
  String catname;

  WallpaperModelClass(
      {
        required this.id,
        required this.title,
        required this.catname,
        required this.imageUrl
      });
// static List<RingtoneModelClass> list = [
//   RingtoneModelClass(1, "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 2,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 3,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 4,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 5,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 6,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 6,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 6,  "https://esalon.pk/ringtone/naat.mp3"),
//   RingtoneModelClass( 6,  "https://esalon.pk/ringtone/naat.mp3")
// ];
// factory CategoryModelClass.fromJson(Map<String, dynamic> json) {
//   return CategoryModelClass(
//     id: json['categoryid'],
//     categoryname: json['categoryname'],
//     categoryurl: json['categoryurl'],
//   );
// }
}
