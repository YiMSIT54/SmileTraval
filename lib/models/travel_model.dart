class TravelModel {
  // Field
  String name, url, detail;


  // Method
  TravelModel(this.name, this.url, this.detail);

  TravelModel.fromJsonMap(Map<String, dynamic> map) {
    name = map['Name'];
    url = map['Url'];
    detail = map['Detail'];
  }


}