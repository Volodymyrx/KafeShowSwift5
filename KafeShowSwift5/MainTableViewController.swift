//
//  MainTableViewController.swift
//  KafeShowSwift5
//
//  Created by v on 02.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRestaurant", for: indexPath) as! CafeTableViewCell
        let place = places[indexPath.row]
        cell.labelName.text = " \(indexPath.row + 1) \(place.name)"
        cell.labelLocation.text = place.locatin
        cell.labelType.text = place.type
        cell.imageCell.image = UIImage(data: place.imageDate!)
        
        cell.imageCell.layer.cornerRadius = cell.imageCell.frame.size.height / 2
        cell.imageCell.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let place = places[indexPath.row]
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//
//
//
//        return [deleteAction]
//    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let place = places[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let deleteSwipe  = UISwipeActionsConfiguration(actions: [deleteAction])
        
        
        return deleteSwipe
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // MARK: navigation
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newPlaceSourseViewController = segue.source as? NewPlaceTableViewController else {return}
        newPlaceSourseViewController.savePlace()
        tableView.reloadData()
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place = places[indexPath.row]
            let goalViewController = segue.destination as! NewPlaceTableViewController
            goalViewController.currentPlace = place
        }
    }
    
}
