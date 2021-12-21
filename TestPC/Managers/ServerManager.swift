//
//  ServerManager.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import Foundation
import Alamofire

typealias ErrorString = String

class ServerManager {
    static let shared = ServerManager()
    
    fileprivate init() { }
    
    fileprivate func getUrl(_ request: String) -> String {
        let serverUrl = Constants.Api.serverUrl
        let url = serverUrl + "/" + request
        return url
    }
    
    func loadUsers(completion: @escaping (ErrorString?, [User]?) -> Void) {
        let request = "users"
        loadData(request: request, parameters: nil, decodableType: [User].self) { errorString, value in
            completion(errorString, value)
        }
    }
    
    func loadPostsForUser(userId: Int, completion: @escaping (ErrorString?, [Post]?) -> Void) {
        let request = "posts"
        let parameters = ["userId": "\(userId)"]
        loadData(request: request, parameters: parameters, decodableType: [Post].self) { errorString, value in
            completion(errorString, value)
        }
    }
    
    func loadCommentsForPost(postId: Int, completion: @escaping (ErrorString?, [Comment]?) -> Void) {
        let request = "comments"
        let parameters = ["postId": "\(postId)"]
        loadData(request: request, parameters: parameters, decodableType: [Comment].self) { errorString, value in
            completion(errorString, value)
        }
    }
    
    fileprivate func loadData<T: Decodable>(request: String, parameters: [String: String]?, decodableType: T.Type, completion: @escaping (ErrorString?, T?) -> Void) {
        let url = getUrl(request)
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).validate().responseDecodable(of: decodableType) { response in
                switch response.result {
                    case .success(let value):
                        completion(nil, value)
                    case let .failure(error):
                        print(error)
                        completion(error.localizedDescription, nil)
                    }
        }
    }
}
