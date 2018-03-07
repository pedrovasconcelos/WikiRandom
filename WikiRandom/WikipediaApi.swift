//
//  WikipediaApi.swift
//  WikiRandom
//
//  Created by Pedro Vasconcelos on 06/03/2018.
//  Copyright © 2018 Pedro Vasconcelos. All rights reserved.
//

import Foundation
import Moya

enum WikipediaApi {
    case random(limit: Int)
}

// MARK: - TargetType

extension WikipediaApi: TargetType {
    var baseURL: URL { return URL(string: "https://en.wikipedia.org/w/api.php")! }
    
    var path: String {
        switch self {
        case .random:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .random:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .random(limit):
            let parameters = [
                "action": "query",
                "format": "json",
                "prop": "extracts|pageimages|revisions",
                "titles": "Main Page",
                "generator": "random",
                "exchars": "600",
                "exlimit": "20",
                "exintro": "1",
                "explaintext": "1",
                "exsectionformat": "plain",
                "piprop": "original",
                "rvprop": "timestamp",
                "grnnamespace": "0",
                "grnlimit": "\(limit)"
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
