//
//  RequestManager.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 31/01/24.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: APIRequestProtocol) async throws -> T
}

class RequestManager : RequestManagerProtocol {
    
    let apiManager : APIManagerProtocol
    let parser : DataParserProtocol
        
    init(apiManager : APIManagerProtocol = APIManager(), parser : DataParserProtocol = DataParser()){
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func perform<T>(_ request: APIRequestProtocol) async throws -> T where T : Decodable {
        let data = try await apiManager.perform(request: request)
        let decodedVal : T = try parser.parse(data)
        return decodedVal
    }
    
}


