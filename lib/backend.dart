import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:logger/logger.dart';

// Create a logger instance
final logger = Logger();

Future<List<String>> fetchBusinessResults(
    String countryCode, String keyword) async {
  String url =
      'https://www.google.com/search?q=whatsapp+$countryCode+$keyword+AND+site:facebook.com&num=100';
  logger.i('Fetching URL: $url'); // Log the URL

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    logger.i('Request successful!'); // Log success
    logger.d(
        'Response body: ${response.body}'); // Log the raw response (this can be long, so it's marked as debug)

    // Parse the HTML document
    var document = parse(response.body);

    // Extract Google search result titles (modify the selector accordingly)
    var results = document.querySelectorAll('.g h3');

    if (results.isNotEmpty) {
      // Log the parsed results
      List<String> scrapedResults = results.map((e) => e.text).toList();
      logger.i('Scraped Results: $scrapedResults');
      return scrapedResults;
    } else {
      logger.w('No results found in the HTML document');
      return [];
    }
  } else {
    logger.e('Failed to load the page: ${response.statusCode}');
    return [];
  }
}
