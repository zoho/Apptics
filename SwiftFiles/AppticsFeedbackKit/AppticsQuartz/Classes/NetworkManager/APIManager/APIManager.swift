//
//  APIManager.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 31/01/24.
//

import Foundation

protocol APIManagerProtocol {
    func perform(request : APIRequestProtocol) async throws -> Data
}


class APIManager : APIManagerProtocol{
    
    private let urlSession : URLSession
    
    init(withSession session : URLSession = URLSession.shared){
        urlSession = session
    }
    
    func perform(request : APIRequestProtocol) async throws -> Data{
        let urlReq = try request.getURLRequest()
        
        let (data, response) = try await urlSession.data(for: urlReq)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw NetworkError.invalidServerResponse }
        return data
    }
}
