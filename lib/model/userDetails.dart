class UserDetails {
  List<String>? alreadyWatched;
  List<String>? watchLater;
  String? url;

  UserDetails({this.alreadyWatched, this.watchLater, this.url});

  UserDetails.fromJson(Map<String, dynamic> json) {
    alreadyWatched = json['AlreadyWatched'].cast<String>();
    watchLater = json['WatchLater'].cast<String>();
    url = json["ProfilePic"];
  }

  get AlreadyWatched => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AlreadyWatched'] = alreadyWatched;
    data['WatchLater'] = watchLater;
    return data;
  }
}
