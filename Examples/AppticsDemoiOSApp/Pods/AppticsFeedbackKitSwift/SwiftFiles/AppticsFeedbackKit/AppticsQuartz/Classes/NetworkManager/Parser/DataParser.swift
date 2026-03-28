//
//  DataParser.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 31/01/24.
//

import Foundation

protocol DataParserProtocol {
    func parse<T:Decodable>(_ data : Data) throws -> T
}

class DataParser : DataParserProtocol{
    
    private var decoder: JSONDecoder
    
    
    init(withDecoder decoder : JSONDecoder = JSONDecoder()){
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    func parse<T>(_ data: Data) throws -> T where T : Decodable {
        let decodedValue = try decoder.decode(T.self, from: data)
        return decodedValue
    }
    
}
