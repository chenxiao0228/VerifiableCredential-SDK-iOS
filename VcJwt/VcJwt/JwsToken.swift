/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

enum JwsTokenError: Error {
    case unsupportedAlgorithm(name: String?)
}

public struct JwsToken<T: Claims> {
    
    let headers: Header
    public let content: T
    var signature: Signature?
    
    public init(headers: Header, content: T, signature: Data? = nil) {
        self.headers = headers
        self.content = content
        self.signature = signature
    }
    
    public init?(from encodedToken: String) {
        let decoder = JwsDecoder()
        do {
            self = try decoder.decode(T.self, token: encodedToken)
        } catch {
            print(error)
            return nil
        }
    }
    
    public init?(from encodedToken: Data) {
        guard let stringifiedToken = String(data: encodedToken, encoding: .utf8) else {
            return nil
        }
        self.init(from: stringifiedToken)
    }
    
    public func serialize() throws -> String {
        let encoder = JwsEncoder()
        return try encoder.encode(self)
    }
    
    public mutating func sign(using signer: TokenSigning, withSecret secret: VcCryptoSecret) throws {
        self.signature = try signer.sign(token: self, withSecret: secret)
    }
    
    public func verify(using verifier: TokenVerifying, withPublicKey key: Secp256k1PublicKey) throws -> Bool {
        
        guard self.headers.algorithm == "ES256K" else {
            throw JwsTokenError.unsupportedAlgorithm(name: self.headers.algorithm)
        }
        
        return try verifier.verify(token: self, usingPublicKey: key)
    }
    
    func getProtectedMessage() throws -> String {
        let encoder = JSONEncoder()
        let encodedHeader = try encoder.encode(self.headers).base64URLEncodedString()
        let encodedContent = try encoder.encode(self.content).base64URLEncodedString()
        return encodedHeader  + "." + encodedContent
    }
}

public typealias Signature = Data
