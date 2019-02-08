//
//  Artwork.swift
//  BeBrav
//
//  Created by bumslap on 06/02/2019.
//  Copyright © 2019 bumslap. All rights reserved.
//

import UIKit

struct ArtworkEncodeType: Encodable {
    let artworkUid: String
    let artworkUrl: String
    let title: String
    let timestamp: [String: String]
    let views: Int 
    
    init(uid: String,
         url: String,
         title: String,
         timestamp: [String: String],
         views: Int) {
        
        self.artworkUid = uid
        self.artworkUrl = url
        self.title = title
        self.timestamp = [:]
        self.views = views
    }
    
    init() {
        self.artworkUid = ""
        self.artworkUrl = ""
        self.title = ""
        self.timestamp = [:]
        self.views = 0
    }
}

struct ArtworkDecodeType: Decodable {
    let artworkUid: String
    let artworkUrl: String
    let timestamp: Double
    let title: String
    let views: Int
    
    init() {
        self.artworkUid = ""
        self.artworkUrl = ""
        self.title = ""
        self.timestamp = 0
        self.views = 0
    }
}

extension ArtworkDecodeType: Comparable {
    static func < (lhs: ArtworkDecodeType, rhs: ArtworkDecodeType) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}


struct Artworks: Decodable {
    let artworks: [String: ArtworkDecodeType]
}
