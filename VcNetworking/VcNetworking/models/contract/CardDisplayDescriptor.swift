/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct CardDisplayDescriptor: Codable, Equatable {
    
    public let title: String?
    public let issuedBy: String?
    public let backgroundColor: String?
    public let textColor: String?
    public let logo: LogoDisplayDescriptor?
    public let cardDescription: String?

    enum CodingKeys: String, CodingKey {
        case title, issuedBy, backgroundColor, textColor, logo
        case cardDescription = "description"
    }
}
