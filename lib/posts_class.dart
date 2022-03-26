import 'package:flutter/material.dart';

class Posts {
  String _caption;
  String _email;
  String _url;
  String _user_img;
  String _name;
  String _id;

  Posts(this._caption, this._email, this._url, this._user_img, this._name,
      this._id);

  String get name => _name;

  String get id => _id;

  set id(String value) {
    id = value;
  }

  set name(String value) {
    _name = value;
  }

  String get user_img => _user_img;

  set user_img(String value) {
    _user_img = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get caption => _caption;

  set caption(String value) {
    _caption = value;
  }
}
