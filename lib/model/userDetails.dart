class UserDetails {
  List<String>? alreadyWatched;
  List<String>? watchLater;

  UserDetails({this.alreadyWatched, this.watchLater});

  UserDetails.fromJson(Map<String, dynamic> json) {
    alreadyWatched = json['AlreadyWatched'].cast<String>();
    watchLater = json['WatchLater'].cast<String>();
  }

  get AlreadyWatched => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AlreadyWatched'] = this.alreadyWatched;
    data['WatchLater'] = this.watchLater;
    return data;
  }
}
