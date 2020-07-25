//
//  FetchPresentationRequest.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class FetchPresentationRequest: FetchNetworkOperation<Contract> {
    
    init(withUrl urlStr: String, serializer: Serializer = Serializer(), urlSession: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        let urlRequest = URLRequest(url: url)
        super.init(urlRequest: urlRequest, serializer: serializer, urlSession: urlSession)
    }
    
}
