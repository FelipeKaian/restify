<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

**Restify** is a versatile Flutter package that simplifies making RESTful API requests in your Flutter application. It provides a clean and intuitive API for sending HTTP requests and handling responses, making it easier to integrate external services and data into your app.

## Features

- **Simple API Calls**: Easily make GET, POST, PUT, DELETE, and PATCH requests with minimal code.
- **JSON Serialization**: Automatically serialize and deserialize JSON data.
- **Error Handling**: Convenient error handling and response status checks.
- **Custom Headers**: Include custom headers with your requests.
- **Async/Await**: Supports asynchronous operations for non-blocking requests.
- **Query Parameters**: Construct query parameters effortlessly.

## Getting started

To start using Restify, 

```bash
flutter pub add restify
```

or add the Restify package to your `pubspec.yaml` file:

```yaml
dependencies:
  restify: ^1.0.0
```

## Usage

```dart
UserModel user = await Restify.get<UserModel>('/user');
```

## Additional information

My name is Felipe Kaian, I am the author of this package, you can find me on LinkedIn or through the email felipekaianmutti@gmail.com. You can bring improvements, suggestions, and feedback – the more, the better. I hope this package helps our Flutter community grow even more!
