//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Blake Andrew Price on 11/4/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    var title: String
    var creator: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults: Codable {
    let results: [SearchResult]
}
