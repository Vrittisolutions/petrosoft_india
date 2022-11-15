class HomePageClass{
  int userId;
  int id;
  String title;
  bool completed;
  HomePageClass({required this.userId,required this.id, required this.title, required this.completed});


  HomePageClass.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'id': id,
    'title' : title,
    'completed' : completed
  };

}