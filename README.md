# flutter_bloc
This is a sample of using BLoC architecture (Clean and MVVM architecture) in flutter.

## App structure would be:

Screen -> Bloc -> Repository -> API Interface -> Model

Any class in left side will have/create instance of right side class. Left class will have access to right side classes properties and methods. If a class from right side need to call class in the left it should use observer pattern. Left class should observe right class to get triggered on changes.

## Dependency injection

I have used [GetIt](https://pub.dev/packages/get_it) as dependency injector. All dependencies set up on creating App widegt.

## Unit testing

I have use [Mockito](https://pub.dev/packages/mockito) to mock classes. Here I just mocked Http Client class to return respose of api requests.
