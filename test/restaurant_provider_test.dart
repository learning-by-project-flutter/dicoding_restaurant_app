import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dicoding_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant.dart';
import 'package:dicoding_restaurant_app/static/restaurant_state.dart';
import 'mock_api_services.mocks.dart'; // Import mock ApiServices

void main() {
  group('RestaurantProvider', () {
    late RestaurantProvider restaurantProvider;
    late MockApiServices mockApiServices;

    setUp(() {
      mockApiServices = MockApiServices();
      restaurantProvider = RestaurantProvider(apiServices: mockApiServices);
    });

    // Skenario 1: Memastikan state awal provider harus didefinisikan
    test('Initial state should be RestaurantInitial', () {
      expect(restaurantProvider.state, isA<RestaurantInitial>());
    });

    // Skenario 2: Memastikan harus mengembalikan daftar restoran ketika pengambilan data API berhasil
    test('Should return list of restaurants when API call is successful',
        () async {
      // Mock respons API yang berhasil
      final mockRestaurants = [
        Restaurant(
            id: '1',
            name: 'Restaurant A',
            description: 'Description A',
            pictureId: 'picture_a',
            city: 'City A',
            rating: 4.5),
        Restaurant(
            id: '2',
            name: 'Restaurant B',
            description: 'Description B',
            pictureId: 'picture_b',
            city: 'City B',
            rating: 4.0),
      ];

      when(mockApiServices.fetchRestaurants())
          .thenAnswer((_) async => mockRestaurants);

      // Panggil fungsi fetchRestaurants
      await restaurantProvider.fetchRestaurants();

      // Verifikasi state berubah menjadi RestaurantSuccess
      expect(restaurantProvider.state, isA<RestaurantSuccess>());

      // Verifikasi daftar restoran tidak kosong
      final state = restaurantProvider.state as RestaurantSuccess;
      expect(state.restaurants.length, 2);
      expect(state.restaurants[0].name, 'Restaurant A');
      expect(state.restaurants[1].name, 'Restaurant B');
    });

    // Skenario 3: Memastikan harus mengembalikan kesalahan ketika pengambilan data API gagal
    test('Should return error when API call fails', () async {
      // Mock respons API yang gagal
      when(mockApiServices.fetchRestaurants())
          .thenThrow(Exception('Failed to load restaurants'));

      // Panggil fungsi fetchRestaurants
      await restaurantProvider.fetchRestaurants();

      // Verifikasi state berubah menjadi RestaurantError
      expect(restaurantProvider.state, isA<RestaurantError>());

      // Verifikasi pesan error
      final state = restaurantProvider.state as RestaurantError;
      expect(state.message,
          'Gagal memuat restoran: Exception: Failed to load restaurants');
    });
  });
}
