class Comments {
  String _comment;
  int _status;
  String _email;
  String _user_img;
  String _name;
  String _id;
  String _time;

  Comments(this._comment, this._status, this._email, this._user_img, this._name,
      this._id, this._time);

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
  }

  int get status => _status;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get user_img => _user_img;

  set user_img(String value) {
    _user_img = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  set status(int value) {
    _status = value;
  }
}
