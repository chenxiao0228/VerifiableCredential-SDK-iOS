/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct ClaimDescriptor: Codable, Equatable {
    let claim: String = ""
    let claimRequired: Bool = false
    let indexed: Bool = false

    enum CodingKeys: String, CodingKey {
        case claim
        case claimRequired = "required"
        case indexed
    }
}
