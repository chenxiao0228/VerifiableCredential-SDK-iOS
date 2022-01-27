/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum PresentationResponseError: Error {
    case noAudienceInRequest
    case noAudienceDidInRequest
}

public struct PresentationResponseContainer: ResponseContaining {
    let request: PresentationRequest
    let expiryInSeconds: Int
    public let audienceUrl: String
    public let audienceDid: String
    public var requestedIdTokenMap: RequestedIdTokenMap = [:]
    public var requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    public var requestVCMap: RequestedVerifiableCredentialMap = [:]
    
    public init(from presentationRequest: PresentationRequest, expiryInSeconds exp: Int = 3000) throws {
        
        guard let audience = presentationRequest.content.clientID else {
            throw PresentationResponseError.noAudienceInRequest
        }
        
        guard let audienceDid = presentationRequest.content.issuer else {
            throw PresentationResponseError.noAudienceDidInRequest
        }

        self.audienceUrl = audience
        self.audienceDid = audienceDid
        self.request = presentationRequest
        self.expiryInSeconds = exp
    }
}
