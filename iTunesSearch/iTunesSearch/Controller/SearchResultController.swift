//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Blake Andrew Price on 11/4/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation

class SearchResultController {
    var searchResults: [SearchResult] = []
    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void ) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "term", value: searchTerm)
        let searchEntityQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)
        urlComponents?.queryItems = [searchTermQueryItem, searchEntityQueryItem]
        
        
        guard let requestURL = urlComponents?.url else {
            completion("request URL is nil")
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                completion("No data return from data task.")
                return
            }
            print(String(bytes: data, encoding: .utf8)!)
            let jsonDecoder = JSONDecoder()
            do {
                let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResults.results
            } catch {
                completion("Unable to decode data into object of type [SearchResult]: \(error)")
                return
            }
            completion(nil)
        }.resume()
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

