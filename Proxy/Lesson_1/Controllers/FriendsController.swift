//
//  FriendsController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 07.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsController: UITableViewController {
    let friendService: ServiceProtocol = DataForServiceProtocol()
    
    var sections: [Results<User>] = []
    //массив NotificationToken так как несколько сейций
    var tokens: [NotificationToken] = []
    var filteredSections: [Results<User>] = []
    
    var sectionsForBuild: [Results<User>] {
        searchController.isActive ? filteredSections : sections
    }
    
    var cachedAvatars = [String: UIImage]()
    
    let searchController: UISearchController = .init()
    
    //функция подготавливающая секции
    func prepareSections() {
        do {
            let realm = try Realm()
            //получаем весь список букв всех друзей. При помощи Set и Array осталяем только уникальные буквы и сортируем
            let friendsABC = Array( Set( realm.objects(User.self).compactMap{ $0.firstName.first?.uppercased() } ) ).sorted()
            //делаем секции
            sections = friendsABC.map { realm.objects(User.self).filter("firstName BEGINSWITH[c] %@", $0) }
            //очищаем масив с токенами если они там были
            tokens.removeAll()
            //подписываемся в каждой секции
            sections.enumerated().forEach{ observeUser(section: $0.offset, results: $0.element) }
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func observeUser(section: Int, results: Results<User>) {
        tokens.append(
            results.observe { (changes) in
                switch changes {
                case .initial:
                    //перезагружаем не всю таблицу а определённую секцию, так как знаем её номер
                    self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    
                case .update(_, let deletions, let insertions, let modifications):
                    //массовый апдейт при помощи beginUpdates() и endUpdates()
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                    self.tableView.insertRows(at: insertions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                    self.tableView.reloadRows(at: modifications.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                    self.tableView.endUpdates()
                    
                case .error(let error):
                    print(error.localizedDescription)
                    
                }
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        friendService.loadUsers() {
            self.prepareSections()
            self.tableView.reloadData()
        }
        
        //регистрируем xib header
        tableView.register(UINib(nibName: "FriendCellXIBView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
    }
    
    // MARK: - Подготовка к перходу на CollectionView
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Получаем ссылку на контроллер, на который осуществлен переход
        guard let destination = segue.destination as? DetailedController,
            let cell = sender as? FriensCell else { return }
        
        destination.nameLabelDetail = cell.firstName
        destination.image = cell.ImagePic.image
        destination.id = cell.id
        destination.lastNameLabelDetail = cell.lastName
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsForBuild.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsForBuild[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //формируем title для header секций
        return sectionsForBuild[section].first?.firstName.first?.uppercased()
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // делаем массив плоским
        let sectionsJoined = sectionsForBuild.joined()
        
        // трансформируем в массив первых букв
        let letterArray = sectionsJoined.compactMap{ $0.firstName.first?.uppercased() }
        
        // убираем неуникальные значения
        let set = Set(letterArray)
        
        return Array(set).sorted()
    }
    
    //функция загрузки иконок если они отсутствуют в кэше
    let queue = DispatchQueue(label: "download_queue")
    private func downloadImage( for url: String, indexPath: IndexPath ) {
        queue.async {
            if self.cachedAvatars[url] == nil {
                if let image = self.friendService.getImageByURL(imageURL: url) {
                    self.cachedAvatars[url] = image
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriensCell", for: indexPath) as? FriensCell else {
            preconditionFailure("Can't create FriensCell")
        }
        
        let friend = sectionsForBuild[indexPath.section][indexPath.row]
        
        let url = friend.image
        
        //заполнение ячейки
        cell.FriendsLabel.text = friend.firstName + " " + friend.lastName
        cell.id = friend.id
        cell.firstName = friend.firstName
        cell.lastName = friend.lastName
        
        //применяем кэширование иконок групп
        if let cached = cachedAvatars[url] {
            cell.ImagePic.image = cached
        } else {
            downloadImage(for: url, indexPath: indexPath)
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension FriendsController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        if let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            filteredSections = sections.map { $0.filter("lastName CONTAINS[c] %@ OR firstName CONTAINS[c] %@", text, text) }
            tableView.reloadData()
        }
    }
}

//extension MyGroupsController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let groups = groups, let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else { return }
//
//        if text.isEmpty {
//            filteredGroup = Array(groups)
//            tableView.reloadData()
//        }
//
//        filteredGroup = groups.filter{ $0.name.lowercased().contains(text) }
//        self.tableView.reloadData()
//    }
//}

//Отображение изменения цвета, радиуса и прозрачности тени
@IBDesignable class ViewImage: UIView {
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 6.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.7 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
}
