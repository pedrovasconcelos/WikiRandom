//
//  Result.swift
//  WikiRandom
//
//  Created by Pedro Vasconcelos on 06/03/2018.
//  Copyright © 2018 Pedro Vasconcelos. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}
