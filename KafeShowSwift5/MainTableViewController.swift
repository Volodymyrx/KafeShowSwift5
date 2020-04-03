//
//  MainTableViewController.swift
//  KafeShowSwift5
//
//  Created by v on 02.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRestaurant", for: indexPath) as! CafeTableViewCell
        
        cell.labelName.text = " \(indexPath.row + 1) \(restaurantNames[indexPath.row])"
        cell.labelLocation.text = restaurantNames[indexPath.row]
        cell.labelType.text = restaurantNames[indexPath.row]
        cell.imageCell.image = UIImage(named: restaurantNames[indexPath.row])
        cell.imageCell.layer.cornerRadius = cell.imageCell.frame.size.height / 2
        cell.imageCell.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
