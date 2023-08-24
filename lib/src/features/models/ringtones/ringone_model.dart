class RingtoneModelClass {
  int id;
  String audioUrl;
  String title;
  int duration;
  String catname;

  RingtoneModelClass(
      {
    required this.id,
        required this.title,
        required this.duration,
        required this.catname,
        required this.audioUrl
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
