import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_users/src/users_db.dart';
import 'package:lrk_users/users.dart';
import 'package:test/test.dart';

void main() {
  void Function() prepare(void Function(UsersApp, FakeTime) body) {
    return fake((time) {
      var app = UsersApp(MemoryUsersDB());

      body(app, time);

      time.await(app.dispose());
    });
  }

  test('Starts with one user', prepare((app, time) {
    var user = time.await(app.getCurrentUser());
    expect(user, isNotNull);
    expect(user.id, equals(0));
  }));

  test('Must create user before changing', prepare((app, time) {
    expect(() => time.await(app.changeCurrentUser(1)), throwsException);
  }));

  test('First user is 0', prepare((app, time) {
    var newUser = time.await(app.addUser(User()));

    expect(newUser.id, equals(0));
  }));

  test('First user after get current is 1', prepare((app, time) {
    time.await(app.getCurrentUser());

    var newUser = time.await(app.addUser(User()));

    expect(newUser.id, equals(1));
  }));

  test('Change user', prepare((app, time) {
    time.await(app.getCurrentUser());
    time.await(app.addUser(User()));

    var user = time.await(app.changeCurrentUser(1));
    expect(user.id, equals(1));

    user = time.await(app.getCurrentUser());
    expect(user.id, equals(1));
  }));
}
