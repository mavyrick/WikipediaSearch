//
//  Result.swift
//  WikipediaSearch
//
//  Created by Josh Sorokin on 24/10/2019.
//  Copyright © 2019 Josh Sorokin. All rights reserved.
//

import Foundation

struct Result : Codable {
    let geonames : [Geonames]?
    
    enum CodingKeys: String, CodingKey {
        
        case geonames = "geonames"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        geonames = try values.decodeIfPresent([Geonames].self, forKey: .geonames)
    }
    
}

struct Geonames : Codable {
    
    let summary : String?
    let thumbnailImg : String?
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        
        case summary = "summary"
        case thumbnailImg = "thumbnailImg"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        thumbnailImg = try values.decodeIfPresent(String.self, forKey: .thumbnailImg)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
}
