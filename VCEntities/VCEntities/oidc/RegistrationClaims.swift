/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/**
 * Contents of the Registration Property in an OpenID Self-Issued Token Request.
 *
 * @see [OpenID Spec](https://openid.net/specs/openid-connect-registration-1_0.html)
 */
public struct RegistrationClaims: Codable, Equatable {
    
    /// The name of the requester.
    public let clientName: String?
    
    /// The purpose for the request.
    public let clientPurpose: String?
    
    /// Optional terms of service uri.
    public let tosURI: String?
    
    /// Optional logo uri of the requester.
    public let logoURI: String?
    
    /// The identifier types supported to use to respond to request (ex. did).
    public let subjectIdentifierTypesSupported: [String]?
    
    /// The decentralized identity methods supported to use to respond to request (ex. ion).
    public let didMethodsSupported: [String]?
    
    /// The supported Verfiable Presentation Formats and Algorithms to respond to request.
    public let vpFormats: SupportedVerifiablePresentationFormats?

    enum CodingKeys: String, CodingKey {
        case clientName = "client_name"
        case clientPurpose = "client_purpose"
        case didMethodsSupported = "did_methods_supported"
        case logoURI = "logo_uri"
        case subjectIdentifierTypesSupported = "subject_identifier_types_supported"
        case tosURI = "tos_uri"
        case vpFormats = "vp_formats"
    }
}
