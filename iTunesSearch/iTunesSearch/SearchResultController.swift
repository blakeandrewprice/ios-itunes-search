//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Blake Andrew Price on 11/4/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class SearchResultController {
    let baseURL: URL
    var searchResults: [SearchResult] = []
    
    init(baseURL: URL, searchResults: [SearchResult]) {
        self.baseURL = baseURL
        self.searchResults = searchResults
    }
    
    func performSeach(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void ) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "search?term", value: searchTerm)
        urlComponents?.queryItems = [searchTermQueryItem]
        
        
        guard let requestURL = urlComponents?.url else {
            print("request URL is nil")
            //completion()
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data return from data task.")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults.append(contentsOf: searchResults.results)
            } catch {
                print("Unable to decode data into object of type [SearchResult]: \(error)")
            }
            //completion()
        }.resume()
    }
}


