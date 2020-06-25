//
//  AvailableGroupsController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 07.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class AvailableGroupsController: UITableViewController {
    
    let avaGroup = [Groups]()
//        Groups(name: "Мужики за 40", image: UIImage(named: "img11")!),
//        Groups(name: "Автобарахолка", image: UIImage(named: "img12")!),
//        Groups(name: "Сериалы", image: UIImage(named: "img13")!),
//        Groups(name: "Новости недели", image: UIImage(named: "img14")!),
//        Groups(name: "Комиксы", image: UIImage(named: "img15")!)
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avaGroup.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableGroupsCell", for: indexPath) as? AvailableGroupsCell else {
            preconditionFailure("Can't create FriensCell")
        }

        let nameAvaGroups = avaGroup[indexPath.row]
        cell.avaGroupName.text = nameAvaGroups.name
 //       cell.avaGroupImage.image = nameAvaGroups.image

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//@IBDesignable class AvailableGroupViewImage: UIView {
//    
//    @IBInspectable var shadowColor: UIColor = .clear {
//        didSet {
//            self.layer.shadowColor = shadowColor.cgColor
//        }
//    }
//    
//    @IBInspectable var shadowRadius: CGFloat = 6.0 {
//        didSet {
//            self.layer.shadowRadius = shadowRadius
//        }
//    }
//    
//    @IBInspectable var shadowOpacity: Float = 0.7 {
//        didSet {
//            self.layer.shadowOpacity = shadowOpacity
//        }
//    }
//}

