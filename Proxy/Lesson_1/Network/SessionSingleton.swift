//
//  SessionSingleton.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 11.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import SwiftyJSON

class Session {

    static let connect: Session = .init()
    var token: String?
    var userId: String?
    
    func addTokenUserId( token: String, userId: String) {
        self.token = token
        self.userId = userId
    }
    
    private init() {}
    
    private func post ( method: String, queries: [URLQueryItem], completion: @escaping ( JSON ) -> Void  ) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)

        var components = URLComponents ()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/" + method
        components.queryItems = [
            URLQueryItem ( name: "access_token", value: token ),
            URLQueryItem ( name: "user_id", value: userId ),
            URLQueryItem ( name: "v", value: "5.68" )
        ]
        components.queryItems?.append(contentsOf: queries)
        
        var request = URLRequest ( url: components.url! )
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { [completion] (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSON(data: data)
             //   print ( json )
                completion ( json["response"] )
            } catch {
                print ( error.localizedDescription )
            }
        }
        task.resume()
    }
    
    public func receiveFriendList ( completion: @escaping ( JSON ) -> Void ) {
        post ( method: "friends.get", queries: [] ) {[completion] ( json ) in
            if ( json.count > 0 )
            {
                let userArray = json["items"].arrayValue
                var user_ids : String = ""
                for item in userArray
                {
                    if ( !user_ids.isEmpty )
                    {
                        user_ids += ","
                    }
                    user_ids += String ( item.intValue )
                }
                let queries = [
                    URLQueryItem ( name: "user_ids", value: user_ids ),
                    URLQueryItem ( name: "fields", value: "first_name, last_name, photo_100" )
                ]
                self.post ( method: "users.get", queries: queries, completion: completion )
            }
            else
            {
                completion ( [] )
            }
        }
    }
    
}

