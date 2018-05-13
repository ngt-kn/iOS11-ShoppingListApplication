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
    var listItem : Results<ListItem>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)

        cell.textLabel?.text = listItem?[indexPath.row].itemName ?? "Please add an item"

        return cell
    }

    func loadItems() {
        listItem = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        
        tableView.reloadData()
        
    }



}
