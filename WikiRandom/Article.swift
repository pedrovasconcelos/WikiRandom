//
//  Article.swift
//  WikiRandom
//
//  Created by Pedro Vasconcelos on 06/03/2018.
//  Copyright © 2018 Pedro Vasconcelos. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Article {
    let title: String
    let body: String
    let imageUrlString: String?
    let articleUrlString: String
    let lastRevisionAt: Date
}

// MARK: - Init (preserving syhnthesized init)

extension Article {
    init?(_ json: JSON) {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let title = json["title"].string,
            let extract = json["extract"].string,
            let revisions = json["revisions"].array,
            let lastRevisionTimestampString = revisions.first?["timestamp"].string,
            let date = dateFormatter.date(from: lastRevisionTimestampString)
            else { return nil }
        
        self.title = title
        self.body = extract
        self.lastRevisionAt = date
        
        let articleBaseurl = URL(string: "https://en.wikipedia.org/wiki")!
        self.articleUrlString = articleBaseurl.appendingPathComponent(title).absoluteString
        
        // Image URL may or may not be present
        self.imageUrlString = json["original"]["source"].string
    }
}
