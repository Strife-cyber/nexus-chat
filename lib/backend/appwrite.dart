import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv for environment variables

// Appwrite provider with explicit type
final appWriteProvider =
    Provider<Future<Client>>((ref) => Appwrite().initialize());

class Appwrite {
  // Method to initialize Appwrite client
  Future<Client> initialize() async {
    // Load the environment variables
    await dotenv.load(fileName: '.env');

    try {
      // Get the project ID from the environment
      final String? projectId = dotenv.env['PROJECT_ID'];

      if (projectId == null) {
        throw Exception('Project ID not found in environment variables');
      }

      // Initialize the Appwrite client
      Client client = Client();
      client.setProject(projectId); // Set project ID
      client.setEndpoint('https://cloud.appwrite.io/v1');

      return client;
    } catch (e) {
      // Handle errors during initialization
      throw Exception('Failed to initialize Appwrite client: $e');
    }
  }
}
