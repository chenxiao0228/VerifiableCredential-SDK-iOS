//
//  Contract.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

struct Contract: Serializable, Codable {
    
    let test: String
    let id: String

    func serialize() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func deserialize(object: Data) throws -> Serializable {
        let decoder = JSONDecoder()
        return try decoder.decode(Contract.self, from: object)
    }
    
    
}
