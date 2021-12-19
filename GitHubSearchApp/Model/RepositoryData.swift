//
//  RepositoryData.swift
//  GitHubSearchApp
//
//  Created by Hang Gao on 2021/12/17.
//

import Foundation

struct RepositoryData: Codable {
    let fullName: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
    }
}
