//
//  APIError.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/7/21.
//  Copyright © 2021 Me. All rights reserved.
//

import Foundation

struct APIError : Codable {
    let errors : [Errors]?
    
    enum CodingKeys: String, CodingKey {
        case errors = "errors"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errors = try values.decodeIfPresent([Errors].self, forKey: .errors)
    }
    
}


struct Errors : Codable {
    let name : String?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
