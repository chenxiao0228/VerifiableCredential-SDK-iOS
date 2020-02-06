//
//  CryptoKeyPair.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class CryptoKeyPair: NSObject {
    
    let publicKey: CryptoKey
    
    let privateKey: CryptoKey
    
    init(publicKey: CryptoKey, privateKey: CryptoKey) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

}
