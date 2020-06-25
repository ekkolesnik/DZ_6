//
//  ActionVK.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 15.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

protocol ServiceProtocol {
    func loadUsers(completion: @escaping () -> Void)
    func loadGroups(handler: @escaping () -> Void)
    func loadPhotos(addParameters: [String: String], completion: @escaping ([Photo]) -> Void)
    func getImageByURL(imageURL: String) -> UIImage?
}

// MARK: - Class DataForServiceProtocol: ServiceProtocol (API + Parse)

class DataForServiceProtocol: ServiceProtocol {
    
    private let apiKey = Session.connect.token
    private let baseUrl = "https://api.vk.com"
    private let firebaseServise: FirebaseServise = .init()

// Загрузка друзей
    func loadUsers(completion: @escaping () -> Void) {
        
        let path = "/method/friends.get"
        let db: UsersDataBase = .init()
        
        let parameters = [
            "user_id": Session.connect.userId,
            "order": "random",
            "fields" : "photo_200",
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseUrl + path
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let friends: [User] = self.usersParser(data: data)
                do {
                    try db.save(users: friends)
                } catch {

                }
                completion()
            }
        }
    }
    
// Загрузка групп
    func loadGroups(handler: @escaping () -> Void) {
        
        let path = "/method/groups.get"
        let db: GroupsDataBase = .init()
        
        let parameters = [
            "user_id": Session.connect.userId,
            "extended": "1",
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseUrl + path
        
        AF.request(url, parameters: parameters).responseJSON { [handler] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let groups: [Groups] = self.groupsParser(data: data)
                //print(groups)
                do {
                    try db.save(groups: groups)
                    handler()
                } catch {

                }
            }
        }
    }
// Загрузка фотографий
    func loadPhotos(addParameters: [String: String], completion: @escaping ([Photo]) -> Void) {
        
        let path = "/method/photos.get"
        let db: PhotoDataBase = .init()
        
        var parameters = [
         //   "owner_id": Session.connect.userId,
            "album_id" : "profile",
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        addParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + path
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let photos: [Photo] = self.photosParser(data: data)
//                print(photos)
                
                do {
                    try db.save(photos: photos)
                    
                } catch {
                    // print(self.db.photoExport())
                }
                
                completion(db.photoExport())
            }
        }
    }

// Функ-я перевода URL в картинку
    func getImageByURL(imageURL: String) -> UIImage? {
        let urlString = imageURL
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageData: Data = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }
        
        return nil
    }

// Парсинг друзей
    private func usersParser(data: Data) -> [User] {
        
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                
                let user = User()
                user.id = item["id"].intValue
                user.firstName = item["first_name"].stringValue
                user.lastName = item["last_name"].stringValue
                user.image = item["photo_200"].stringValue
                
                return user
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
// Парсинг груп
    private func groupsParser(data: Data) -> [Groups] {
        
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Groups in
                
                let group = Groups()
                
                group.name = item["name"].stringValue
                group.image = item["photo_100"].stringValue
                group.id = item["id"].intValue
                
                firebaseServise.firebaseAddGroup(group: group)
                
                return group
            }
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
// Парсинг фотографий
    private func photosParser(data: Data) -> [Photo] {
        
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Photo in
                
                let photo = Photo()
                photo.id = item["id"].intValue
                photo.ownerId = item["owner_id"].intValue
                
                let sizeValues = item["sizes"].arrayValue
                if let last = sizeValues.last {
                    photo.imageURL = last["url"].stringValue
                }
                
                return photo
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

// MARK: - Class DataBase for REALM

class UsersDataBase {
    func save( users: [User] ) throws {
        let realm = try Realm()
        //        print(realm.configuration.fileURL)
        realm.beginWrite()
        realm.add(users, update: .modified)
        try realm.commitWrite()
    }
    
    func userExport() -> [User] {
        do {
            let realm = try Realm()
            let objects = realm.objects(User.self)
            return Array(objects)
        } catch {
            return []
        }
    }
}

class GroupsDataBase {
    func save( groups: [Groups] ) throws {
        let realm = try Realm()
      //  print(realm.configuration.fileURL)
        realm.beginWrite()
        realm.add(groups, update: .modified)
        try realm.commitWrite()
    }
    
    func groupExport() -> [Groups] {
        do {
            let realm = try Realm()
            let objects = realm.objects(Groups.self)
            return Array(objects)
        } catch {
            return []
        }
    }
}

class PhotoDataBase {
    func save( photos: [Photo] ) throws {
        let realm = try Realm()
        realm.beginWrite()
        let oldPhoto = realm.objects(Photo.self)
        realm.delete(oldPhoto)
        realm.add(photos)
        try realm.commitWrite()
    }
    
    func photoExport() -> [Photo] {
        do {
            let realm = try Realm()
            let objects = realm.objects(Photo.self)  //.filter("ownerId = %@", id)
            return Array(objects)
        } catch {
            return []
        }
    }
}
