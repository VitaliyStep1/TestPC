//
//  User.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String?
}

//extension User: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case username
//        case email
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(Int.self, forKey: .id)
//        name = try values.decode(String.self, forKey: .name)
//        username = try values.decode(String.self, forKey: .username)
//        email = try values.decode(String?.self, forKey: .email)
//    }
//}

//    "id": 1,
//    "name": "Leanne Graham",
//    "username": "Bret",
//    "email": "Sincere@april.biz",
//    "address": {
//    "street": "Kulas Light",
//    "suite": "Apt. 556",
//    "city": "Gwenborough",
//    "zipcode": "92998-3874",
//    "geo": {
//    "lat": "-37.3159",
//    "lng": "81.1496"
//    }
//    },
//    "phone": "1-770-736-8031 x56442",
//    "website": "hildegard.org",
//    "company": {
//    "name": "Romaguera-Crona",
//    "catchPhrase": "Multi-layered client-server neural-net",
//    "bs": "harness real-time e-markets"
//    }
