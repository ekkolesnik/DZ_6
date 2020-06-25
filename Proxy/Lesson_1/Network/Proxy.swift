//
//  Proxy.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 25.06.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class GroupProxy: ServiceProtocol {
    
    var dataForServiceProtocol: DataForServiceProtocol
    
    init(dataForServiceProtocol: DataForServiceProtocol) {
        self.dataForServiceProtocol = dataForServiceProtocol
    }
    
    func loadUsers(completion: @escaping () -> Void) {
        print("loadUsers")
    }
    
    func loadGroups(handler: @escaping () -> Void) {
        self.dataForServiceProtocol.loadGroups {}
    }
    
    func loadPhotos(addParameters: [String : String], completion: @escaping ([Photo]) -> Void) {
        print("loadPhotos")
    }
    
    func getImageByURL(imageURL: String) -> UIImage? {
        let urlString = imageURL
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageData: Data = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
    
    //    func getWeather(for city: String, completion: @escaping ([Weather]) -> Void) {
    //        self.weatherService.getWeather(for: city, completion: completion)
    //    }
    
    
    
}
