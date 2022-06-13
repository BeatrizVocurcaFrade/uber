class LocalUser {
  String? id;
  String? _name;
  String? _email;
  String? _password;
  String? _type;

  LocalUser({
    id,
    name,
    email,
    password,
    type,
  });
  
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'name': _name, 'email': _email, 'type': _type};
    return map;
  }

  get name => _name;

  set name(value) => _name = value;

  get email => _email;

  set email(value) => _email = value;

  get password => _password;

  set password(value) => _password = value;

  get type => _type;

  set type(value) => _type = value;
}
