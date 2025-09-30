import 'package:carbon_it_images_search/data/mappers/pexels_images_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test mapper', () {
    test('When providing a map of 1 item, should return a list of 1 ImageEntity', () {
      // Given
      final resultId = 3573351;
      final Map<String, dynamic> json = {
        "total_results": 10000,
        "page": 1,
        "per_page": 1,
        "photos": [
          {
            "id": resultId,
            "width": 3066,
            "height": 3968,
            "url": "https://www.pexels.com/photo/trees-during-day-3573351/",
            "photographer": "Lukas Rodriguez",
            "photographer_url": "https://www.pexels.com/@lukas-rodriguez-1845331",
            "photographer_id": 1845331,
            "avg_color": "#374824",
            "src": {
              "original": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png",
              "large2x":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
              "large":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=650&w=940",
              "medium":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=350",
              "small":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130",
              "portrait":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
              "landscape":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
              "tiny":
                  "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280",
            },
            "liked": false,
            "alt": "Brown Rocks During Golden Hour",
          },
        ],
        "next_page": "https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature",
      };

      // When
      final result = PexelsImagesMapper.parseJson(json);

      // Then
      expect(result.length, 1);
      expect(result.first.id, resultId.toString());
      expect(result.first.source.original, 'https://images.pexels.com/photos/3573351/pexels-photo-3573351.png');
    });
  });
}
