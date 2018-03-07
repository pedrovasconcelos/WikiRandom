//
//  WikipediaService.swift
//  WikiRandom
//
//  Created by Pedro Vasconcelos on 06/03/2018.
//  Copyright © 2018 Pedro Vasconcelos. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

/// Service class used to make network requests to Wikipedia API.
/// Network responses are delivered as domain-specific, ready to use, model objects, such as Article, instead of raw/JSON data.
/// The instance used to make a request must be retained until the request is complete.
class WikipediaService {
    let provider = MoyaProvider<WikipediaApi>()
    
    func getRandomArticles(limit: Int, completionHandler: @escaping (Result<[Article]>) -> ()) {
        provider.request(.random(limit: limit)) { result in
            switch result {
            case let .success(moyaResponse):
                // Note that error codes are not being tested for. The request may be successful and still return an HTTP error code.
                // In case of error, an empty array of articles is returned.
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                let json = JSON(data)
                
                let articlesJson = json["query"]["pages"].dictionaryValue.map { $0.value }
                let articles = articlesJson.flatMap { Article($0) }
                
                completionHandler(Result.success(articles))
                
            case let .failure(error):
                // Moya error is discarded for now. Simple custom error is returned.
                completionHandler(Result.failure(WikiRandomError.standardError))
            }
        }
    }
}
