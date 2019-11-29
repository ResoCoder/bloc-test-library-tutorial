import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_test_tutorial/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  test('Example mocked BLoC test', () {
    whenListen(
      mockWeatherBloc,
      Stream.fromIterable([WeatherInitial(), WeatherLoading()]),
    );

    expectLater(
      mockWeatherBloc,
      emitsInOrder([WeatherInitial(), WeatherLoading()]),
    );
  });
}
