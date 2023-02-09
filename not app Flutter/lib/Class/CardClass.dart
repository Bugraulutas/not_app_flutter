class CardClass{
  String card_id;
  String card_name;
  String card_article;


  CardClass(this.card_id, this.card_name, this.card_article, );

  factory CardClass.fromJson(String key,Map<dynamic,dynamic> json){
    return CardClass(key, json["card_name"] as String, json["card_article"] as String);
  }
}