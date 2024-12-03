//import Foundation
//
//enum APIKey {
//  // Fetch the API key from `GenerativeAI-Info.plist`
//  static var `default`: String {
//    guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
//    else {
//      fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
//    }
//    let plist = NSDictionary(contentsOfFile: filePath)
//    guard let value = plist?.object(forKey: "API_KEY") as? String else {
//      fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
//    }
//    if value.starts(with: "_") {
//      fatalError(
//        "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
//      )
//    }
//    return value
//  }
//}


//import Foundation
//
//enum APIKey {
//  // Fetch the API key from `GenerativeAI-Info.plist`
//  static var `default`: String {
//    // Ensure we can find the file
//    guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
//      fatalError("Couldn't find file 'GenerativeAI-Info.plist'. Make sure it's added to the project.")
//    }
//
//    // Try to read the file into a dictionary
//    guard let plist = NSDictionary(contentsOfFile: filePath) else {
//      fatalError("Failed to read 'GenerativeAI-Info.plist'. Check if the file is valid.")
//    }
//
//    // Retrieve the API key
//    guard let value = plist.object(forKey: "API_KEY") as? String else {
//      fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'. Check if the key is added correctly.")
//    }
//
//    // Debug log for verification
//    print("API Key fetched: \(value)")
//
//    // If API key looks like a placeholder, prompt to follow the setup guide
//    if value.starts(with: "_") {
//      fatalError("Invalid API key. Follow the instructions at https://ai.google.dev/tutorials/setup to get a valid API key.")
//    }
//
//    return value
//  }
//}


import Foundation

enum APIKey {
  // Fetch the API key from `GenerativeAI-Info.plist`
  static var `default`: String {
    guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
    else {
      fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
    }
    if value.starts(with: "_") {
      fatalError(
        "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
      )
    }
    return value
  }
}

