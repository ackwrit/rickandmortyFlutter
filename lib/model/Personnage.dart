


 class Personnage{
  late int id;
  late String name;
  late String image;



  Personnage.json(Map<String,dynamic> map){
    id = map["id"];
    name = map["name"];
    image = map["image"];
  }

 }