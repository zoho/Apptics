//
//  APIRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 31/01/24.
//

import Foundation
import UIKit

protocol APIRequestProtocol {
    var host : String { get }
    var path : String { get }
    var requestHeader : [String : String] { get }
    var requestParam : [String : Any] { get }
    var urlQuery : [String : String] { get }
    var requestType : RequestType { get }
    var shouldIncludeAuthenticationToken : Bool { get }
    
    func getURLRequest(token : String) throws -> URLRequest
    func getContentTypeAndBodyData() -> (String, Data?)
}


extension APIRequestProtocol {
    var host : String {
        "\(APIConstants.host).\(QuartzKit.shared.subDomain)"
    }
    
    var path : String{
        ""
    }
    
    var requestHeader : [String : String] {
        [:]
    }
    
    var requestParam : [String : Any] {
        [:]
    }
    
    var urlQuery : [String : String] {
        [:]
    }
    
    var requestType : RequestType {
        .GET
    }
    
    var shouldIncludeAuthenticationToken : Bool {
        true
    }
    
    func getContentTypeAndBodyData() -> (String, Data?){
        ("application/json",nil)
    }
}

extension APIRequestProtocol{
    
    func getURLRequest(token : String = "") throws -> URLRequest {
        var urlComponenets = URLComponents()
        urlComponenets.scheme = APIConstants.scheme
        urlComponenets.host = host
        urlComponenets.path = path
        urlComponenets.queryItems = urlQuery.map{
            URLQueryItem(name: $0, value: $1)
        }
        urlComponenets.percentEncodedQuery = urlComponenets.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let url = urlComponenets.url else { throw NetworkError.invalidUrl }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !requestHeader.isEmpty{
            urlRequest.allHTTPHeaderFields = requestHeader
        }
        
        if !requestParam.isEmpty{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestParam)
        }
        
        if shouldIncludeAuthenticationToken{
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let (contentType, data) = getContentTypeAndBodyData()
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if let bodyData = data {
            urlRequest.httpBody = bodyData
        }
        urlRequest.addValue(userAgent(), forHTTPHeaderField: "User-Agent")

        return urlRequest
    }
    
    private func userAgent() -> String{
        let bundle = Bundle(for: IssueRecordingViewController.self)
        if let infoDict = bundle.infoDictionary{
            if let name = infoDict["CFBundleName"],
               let version = infoDict["CFBundleShortVersionString"]{
                let uAgent = "\(name)/\(version) (iOS\(UIDevice.current.systemVersion),\(UIDevice.current.model))"
                return uAgent
            }
        }
        return "QuatzKit"
    }
}

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}

enum RequestType : String{
    case POST
    case GET
    case PUT
    case DELETE
    case PATCH
}
