import 'package:flutter/material.dart';
import 'backend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SocialExtractorHomePage(),
    );
  }
}

class SocialExtractorHomePage extends StatefulWidget {
  const SocialExtractorHomePage({super.key});

  @override
  _SocialExtractorHomePageState createState() =>
      _SocialExtractorHomePageState();
}

class _SocialExtractorHomePageState extends State<SocialExtractorHomePage> {
  // Controller to manage the keyword input
  final TextEditingController _keywordController = TextEditingController();

  // Variable to hold the search results
  String _results = 'Results will be displayed here';

  // List of country codes
  List<String> countryCodes = ['+94', '+1', '+44', '+61', '+91'];

  // Initially selected country code
  String selectedCode = '+94';

  @override
  void dispose() {
    _keywordController.dispose(); // Dispose of controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top blue header
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            color: const Color(0xFF42A5F5),
            child: const Center(
              child: Text(
                'Social Extractor',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Main form section
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Phone number and keyword input section
                    Row(
                      children: [
                        // Country code dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCode,
                            icon: const Icon(Icons.arrow_drop_down),
                            underline:
                                const SizedBox(), // To remove the default underline
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCode = newValue!;
                              });
                            },
                            items: countryCodes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Keyword input field
                        Expanded(
                          child: TextField(
                            controller:
                                _keywordController, // Connect controller
                            decoration: InputDecoration(
                              hintText: 'Enter Your Keyword',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Find Business button
                    ElevatedButton(
                      onPressed: () async {
                        // Fetch user inputs
                        String keyword = _keywordController.text;
                        String countryCode = selectedCode;

                        // Fetch business results from backend
                        List<String> results =
                            await fetchBusinessResults(countryCode, keyword);
                        logger.i('Results from backend: $results');

                        // Update the UI with the fetched results
                        setState(() {
                          _results = results.isNotEmpty
                              ? results.join('\n')
                              : 'No results found';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5), // Blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Find Business',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bottom section (Results display)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFF90CAF9), // Lighter blue background
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            _results, // Display the results here
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
