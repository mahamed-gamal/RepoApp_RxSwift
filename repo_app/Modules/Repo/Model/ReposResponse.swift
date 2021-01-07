//
//  ReposResponse.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/7/21.
//  Copyright © 2021 Me. All rights reserved.
//

import Foundation

//struct ReposResponse: Codable {
//    let repos: [Repo]?
//}

struct Repo: Codable {
    let name: String?
    let description: String?
    let forksCount: Int?
    let countributerUrl: String?
    let watchers: Int?
    let openIssues: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, description, watchers
        case forksCount = "forks_count"
        case countributerUrl = "contributors_url"
        case openIssues = "open_issues"
    }
}

struct Contributer: Codable {
    let login: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
  }
}
