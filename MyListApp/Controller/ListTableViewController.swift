//
//  ListTableViewController.swift
//  MyListApp
//
//  Created by Kenneth Nagata on 5/12/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {

    let realm = try! Realm()
    var item: Results<ListItem>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    //MARK: - Data manipulation
    // load items from ream
    func loadItems() {
        // load items from realm for the current category, sorted by itemName
        item = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        
        // reload data for tableview
        tableView.reloadData()
    }
    

    
    // Delete items from realm
    func deleteItems() {

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
}
