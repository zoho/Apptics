//
//  NetworkError.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 31/01/24.
//

import Foundation

enum NetworkError : Error{
    case invalidUrl
    case invalidServerResponse
    
    var description : String{
        switch self {
            case .invalidUrl:
                return "Url String is Invalid"
            case .invalidServerResponse:
                return "Server Returned Invalid Response"
        }
    }
}
