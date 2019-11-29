import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_test_tutorial/bloc/bloc.dart';
import 'package:bloc_test_tutorial/data/model/weather.dart';
import 'package:bloc_test_tutorial/data/weather_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
  });

  group('GetWeather', () {
    final weather = Weather(cityName: 'London', temperatureCelsius: 7);

    test('OLD WAY emits [WeatherLoading, WeatherLoaded] when successful', () {
      when(mockWeatherRepository.fetchWeather(any))
          .thenAnswer((_) async => weather);

      final bloc = WeatherBloc(mockWeatherRepository);

      bloc.add(GetWeather('London'));

      expectLater(
        bloc,
        emitsInOrder([
          WeatherInitial(),
          WeatherLoading(),
          WeatherLoaded(weather),
        ]),
      );
    });

    test(
        'NEWER WAY BUT LONG-WINDED emits [WeatherLoading, WeatherLoaded] when successful',
        () {
      when(mockWeatherRepository.fetchWeather(any))
          .thenAnswer((_) async => weather);

      final bloc = WeatherBloc(mockWeatherRepository);

      bloc.add(GetWeather('London'));

      emitsExactly(bloc, [
        WeatherInitial(),
        WeatherLoading(),
        WeatherLoaded(weather),
      ]);
    });

    blocTest(
      'emits [WeatherLoading, WeatherLoaded] when successful',
      build: () {
        when(mockWeatherRepository.fetchWeather(any))
            .thenAnswer((_) async => weather);
        return WeatherBloc(mockWeatherRepository);
      },
      act: (bloc) => bloc.add(GetWeather('London')),
      expect: [
        WeatherInitial(),
        WeatherLoading(),
        WeatherLoaded(weather),
      ],
    );

    blocTest(
      'emits [WeatherLoading, WeatherError] when unsuccessful',
      build: () {
        when(mockWeatherRepository.fetchWeather(any)).thenThrow(NetworkError());
        return WeatherBloc(mockWeatherRepository);
      },
      act: (bloc) => bloc.add(GetWeather('London')),
      expect: [
        WeatherInitial(),
        WeatherLoading(),
        WeatherError("Couldn't fetch weather. Is the device online?"),
      ],
    );
  });
}
