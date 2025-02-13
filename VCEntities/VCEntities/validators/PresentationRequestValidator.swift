/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

enum PresentationRequestValidatorError: Error {
    case didMethodNotSupported
    case invalidResponseModeValue
    case invalidResponseTypeValue
    case invalidScopeValue
    case invalidSignature
    case noExpirationPresent
    case noRegistrationPresent
    case responseSigningAlgorithmNotSupportedForVCs
    case responseSigningAlgorithmNotSupportedForVPs
    case subjectIdentifierTypeNotSupported
    case tokenExpired
}

public protocol RequestValidating {
    func validate(request: PresentationRequestToken, usingKeys publicKeys: [IdentifierDocumentPublicKey]) throws
}

public struct PresentationRequestValidator: RequestValidating {
    
    private let verifier: TokenVerifying
    
    public init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    public func validate(request: PresentationRequestToken, usingKeys publicKeys: [IdentifierDocumentPublicKey]) throws {
        try validate(token: request, using: publicKeys)
        try validate(expiration: request.content.exp)
        try validate(request.content.scope, equals: VCEntitiesConstants.SCOPE, throws: PresentationRequestValidatorError.invalidScopeValue)
        try validate(request.content.responseMode, equals: VCEntitiesConstants.RESPONSE_MODE, throws: PresentationRequestValidatorError.invalidResponseModeValue)
        try validate(request.content.responseType, equals: VCEntitiesConstants.RESPONSE_TYPE, throws: PresentationRequestValidatorError.invalidResponseTypeValue)
        
        guard let registration = request.content.registration else {
            throw PresentationRequestValidatorError.noRegistrationPresent
        }
        
        try validate(registration: registration)
    }
    
    private func validate(token: PresentationRequestToken,
                          using keys: [IdentifierDocumentPublicKey]) throws {
        
        for key in keys {
            do {
                if try token.verify(using: verifier, withPublicKey: key.publicKeyJwk) {
                    return
                }
            } catch {
                // TODO: log error
            }
        }
        
        throw PresentationRequestValidatorError.invalidSignature
    }
    
    private func validate(expiration: Double?) throws {
        guard let exp = expiration else { throw PresentationRequestValidatorError.noExpirationPresent }
        if getExpirationDeadlineInSeconds() > exp { throw PresentationRequestValidatorError.tokenExpired }
    }
    
    private func validate(_ value: String?, equals correctValue: String, throws error: Error) throws {
        guard value == correctValue else { throw error }
    }
    
    private func validate(registration: RegistrationClaims) throws {
        if let isSubjectIdentifierTypeSupported =         registration.subjectIdentifierTypesSupported?.contains(VCEntitiesConstants.SUBJECT_IDENTIFIER_TYPE_DID),
           !isSubjectIdentifierTypeSupported {
            throw PresentationRequestValidatorError.subjectIdentifierTypeNotSupported
        }
        
        if let isAlgorithmSupportedInVp = registration.vpFormats?.jwtVP?.algorithms?.contains(VCEntitiesConstants.ALGORITHM_SUPPORTED_IN_VP),
           !isAlgorithmSupportedInVp {
            throw PresentationRequestValidatorError.responseSigningAlgorithmNotSupportedForVPs
        }
        
        if let isAlgorithmSupportedInVp = registration.vpFormats?.jwtVC?.algorithms?.contains(VCEntitiesConstants.ALGORITHM_SUPPORTED_IN_VP),
           !isAlgorithmSupportedInVp {
            throw PresentationRequestValidatorError.responseSigningAlgorithmNotSupportedForVCs
        }
    }
    
    private func getExpirationDeadlineInSeconds(expirationCheckTimeOffsetInSeconds: Int = 300) -> Double {
        let currentTimeInSeconds = (Date().timeIntervalSince1970).rounded(.down)
        return currentTimeInSeconds - Double(expirationCheckTimeOffsetInSeconds)
    }
}
