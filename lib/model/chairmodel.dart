class Chairs {
  int id;
  String date;
  String title;
  String description;
  String pic1;
  String pic2;
  String state;

  Chairs({ required this.id, required this.date, required this.title, required this.description, required this.pic1, required this.state,required this.pic2}
     );

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'date': this.date,
      'title': this.title,
      'description': this.description,
      'pic1': this.pic1,
      'pic2': this.pic2,
      'state': this.state,
    };
  }

  factory Chairs.fromMap(Map<String, dynamic> map) {
    return Chairs(
      id: map['id'] as int,
      date: map['date'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      pic1: map['pic1'] as String,
      pic2: map['pic2'] as String,
      state: map['state'] as String,
    );
  }
}
