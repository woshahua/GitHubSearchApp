//
//  Request.swift
//  GitHubSearchApp
//
//  Created by Hang Gao on 2021/12/14.
//

import Foundation

enum HTTPRequestMethod: String {
    case get
    case post
}

protocol Request {
    associatedtype Response: Codable
    
    var urlString: String { get }
    var method: HTTPRequestMethod { get }
    var parameters: [String: Any] { get }
    
    func buildRequest() -> URLRequest?
}
