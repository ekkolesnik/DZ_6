//
//  MyGroupsController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 07.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
    
    let dataFor = DataForServiceProtocol()
//    let groupServiceProxy: ServiceProtocol = GroupProxy(dataForServiceProtocol: dataFor)
    
    let groupService: ServiceProtocol = DataForServiceProtocol()
    var groups: Results<Groups>?
    var groupForSearch = [Groups]()
    var filteredGroup: [Groups] {
        return Array(searchController.isActive ? groupForSearch : myGroupArray)
    }
    var notoficationToken: NotificationToken?
    let searchController = UISearchController()
    var cachedAvatars = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groupServiceProxy: ServiceProtocol = GroupProxy(dataForServiceProtocol: dataFor)
        
        observeMyGroup()
        groupServiceProxy.loadGroups {}
//        groupService.loadGroups { }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        //Обновление данных методом свайпа вниз
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateGroup), for: .valueChanged)
        
        self.tableView.reloadData()
    }
    
    //функция для обновления данных методом свайпа вниз
    @objc func updateGroup() {
        groupService.loadGroups() { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    func observeMyGroup() {
        do {
            let realm = try Realm()
            groups = realm.objects(Groups.self)
            
            notoficationToken = groups?.observe { (changes) in
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView.performBatchUpdates({
                        self.tableView.deleteRows(at: deletions.map{ IndexPath(row: $0, section: 0) }, with: .automatic)
                        self.tableView.insertRows(at: insertions.map{ IndexPath(row: $0, section: 0) }, with: .automatic)
                        self.tableView.reloadRows(at: modifications.map{ IndexPath(row: $0, section: 0) }, with: .automatic)
                    }, completion: nil)
                    
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = filteredGroup[indexPath.row]
        print(group)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroup.count
//        return searchController.isActive ? filteredGroup.count : groups?.count ?? 0
    }
    
    
    //функция загрузки иконок если они отсутствуют в кэше
    let queue = DispatchQueue(label: "download_queue")
    private func downloadImage( for url: String, indexPath: IndexPath ) {
        queue.async {
            if self.cachedAvatars[url] == nil {
                if let image = self.groupService.getImageByURL(imageURL: url) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupCell else {
            preconditionFailure("Can't create MyGroupCell")
        }
        
        let nameMyGroup = filteredGroup[indexPath.row]
        cell.MyGroupNameLabel.text = nameMyGroup.name
        
        let url = filteredGroup[indexPath.row].image
        
        //применяем кэширование иконок групп
        if let cached = cachedAvatars[url] {
            cell.MyGroupImage.image = cached
        } else {
            downloadImage(for: url, indexPath: indexPath)
        }
        return cell
    }
    
    // MARK: - Добавление группы
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        // Проверяем идентификатор перехода, чтобы убедиться, что это нужный
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            guard let availableGroupController = segue.source as? AvailableGroupsController else { return }
            // Получаем индекс выделенной ячейки
            if let indexPath = availableGroupController.tableView.indexPathForSelectedRow {
                // Получаем город по индексу
                let groups = availableGroupController.avaGroup[indexPath.row]
                // Проверяем, что такого города нет в списке
                if !filteredGroup.contains(where: { $0.name == groups.name }) {
                    // Добавляем город в список выбранных
                    groupForSearch.append(groups)
                    // Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        // Если была нажата кнопка «Удалить»
    //        if editingStyle == .delete {
    //        // Удаляем город из массива
    //            filteredGroup.remove(at: indexPath.row)
    //        // И удаляем строку из таблицы
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
    
}

@IBDesignable class MyGroupViewImage: UIView {
    
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

// MARK: - UISearchBarDelegate

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
            groupForSearch = myGroupArray.filter({ $0.name.range(of: text, options: .caseInsensitive) != nil })
            tableView.reloadData()
        
//        guard let groups = groups, let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else { return }
//
//        if text.isEmpty {
//            groupForSearch = Array(groups)
//            tableView.reloadData()
//        }
//
//        groupForSearch = groups.filter{ $0.name.lowercased().contains(text) }
//        self.tableView.reloadData()
    }
}

extension MyGroupsController {
    var myGroupArray: [Groups] {
        guard let groups = groups else { return [] }
        return Array(groups)
    }
}
