/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct InputDescriptor: Codable, Equatable {
    
    public let id: String?
    public let credentialIssuer: String?
    public let issuer: String?
    public let attestations: AttestationsDescriptor?
    
}
