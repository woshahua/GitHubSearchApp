//
//  GithubRepoGetAPI.swift
//  GitHubSearchApp
//
//  Created by Hang Gao on 2021/12/17.
//

import Foundation

struct GitHubRepoGetAPI: Request {
    typealias Response = RepositoryDataList
    
    let urlString = "https://api.github.com/search/repositories"
    let method =  HTTPRequestMethod.get
    let queryName: String
    let page: Int
    let perPage: Int
    
    var parameters: [String : Any] {
        return ["q": queryName, "page": page, "per_page": perPage]
    }
    
    func buildRequest() -> URLRequest? {
        let query = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        guard let url = URL(string: "\(urlString)?\(query)") else { return nil}
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        return req
    }
}
