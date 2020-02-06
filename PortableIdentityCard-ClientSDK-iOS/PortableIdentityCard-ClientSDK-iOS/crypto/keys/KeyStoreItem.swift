//
//  KeyStoreItem.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/31/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

protocol KeyStoreItem: Codable {
    
    var kid: String { get }

}
