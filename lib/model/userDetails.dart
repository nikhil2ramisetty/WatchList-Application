class UserDetails {
  List<bool>? alreadyWatched;
  List<bool>? watchLater;
  String? profilePic;
  List<String>? movies;

  UserDetails(
      {this.alreadyWatched, this.watchLater, this.profilePic, this.movies});

  UserDetails.fromJson(Map<String, dynamic> json) {
    alreadyWatched = json['Already Watched'].cast<bool>();
    watchLater = json['Watch Later'].cast<bool>();
    profilePic = json['ProfilePic'];
    movies = json['Movies'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Already Watched'] = this.alreadyWatched;
    data['Watch Later'] = this.watchLater;
    data['ProfilePic'] = this.profilePic;
    data['Movies'] = this.movies;
    return data;
  }
}
