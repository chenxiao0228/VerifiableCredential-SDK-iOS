/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IdentifierDocument: Codable {
    let service: [String]
    public let verificationMethod: IdentifierDocumentPublicKeyV1
    let authentication: [String]
}
