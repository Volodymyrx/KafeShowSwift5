//
//  MainTableViewController.swift
//  KafeShowSwift5
//
//  Created by v on 02.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UIViewController {
    
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private let searchController = UISearchController(searchResultsController: nil)
    private var revers = false
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
//        tableView.dataSource = self
//        tableView.delegate = self
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search:"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
}

// MARK: - Table view data source
extension MainTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        return places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRestaurant", for: indexPath) as! CafeTableViewCell
        cell.labelName.text = " \(indexPath.row + 1) \(place.name)"
        cell.labelLocation.text = place.locatin
        cell.labelType.text = place.type
        cell.imageCell.image = UIImage(data: place.imageDate!)
        cell.cosmosView.rating = place.rating

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let place = places[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let deleteSwipe  = UISwipeActionsConfiguration(actions: [deleteAction])
        return deleteSwipe
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
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            
            let goalViewController = segue.destination as! NewPlaceTableViewController
            goalViewController.currentPlace = place
        }
    }
    
}
// MARK: Search
extension MainTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR locatin CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}

// MARK: Sorting
extension MainTableViewController {
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func actionReversedSorting(_ sender: UIBarButtonItem) {
        revers = !revers
        reversedSortingButton.image = revers ?  #imageLiteral(resourceName: "AZ") : #imageLiteral(resourceName: "ZA")
        sorting()
    }
    private func sorting(){
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: revers)
        }else{
            places = places.sorted(byKeyPath: "name", ascending: revers)
        }
        tableView.reloadData()
    }
    
}
