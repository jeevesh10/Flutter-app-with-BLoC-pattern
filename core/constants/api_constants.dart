class ApiConstants {
  static const baseUrl = 'https://dummyjson.com';
  static const users = '$baseUrl/users';
  static String posts(int userId) => '$baseUrl/posts/user/$userId';
  static String todos(int userId) => '$baseUrl/todos/user/$userId';
}
