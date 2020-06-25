//
//  NewsController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 19.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class NewsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var data = ["Name one" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "Name two" : "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
    "Name three" : "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",
    "Name four" : "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
    "Name five" : "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium",
    "Name six" : "totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo",
    "Name seven" : "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit",
    "Name eight" : "sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Автоматический подбор высоты ячейки по содержанию
        tableView.rowHeight = UITableView.automaticDimension

    }
}

extension NewsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell else {
            preconditionFailure("Can't create NewsCell")
        }
        
        let keys = [String](data.keys)
        cell.NameLabelNewsCell.text = keys[indexPath.row]
        cell.TextNewsCell.text = data[keys[indexPath.row]]
        
        return cell
    }
    
}
