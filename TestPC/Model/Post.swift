//
//  Post.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

//"userId": 1,
//"id": 1,
//"title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
//"body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
