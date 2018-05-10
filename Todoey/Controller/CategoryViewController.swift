//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/7.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var realm = try! Realm()

    var categories: Results<Category>?  // IMPORTANT: Auto-update when realm updated
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        return cell
    }
    

    
    
    // MARK: - Add New Categories
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create a New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // creat, append, save data, reload table
            let newCategory = Category()
            newCategory.name = textField.text ?? "default category"

            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "type new category name here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    

    // MARK: - TableView Delegate Methods, Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 修改标题，读取相应进度，
        if let destinationVC = segue.destination as? TodoListVC {
            destinationVC.category = categories?[tableView.indexPathForSelectedRow!.row]
            destinationVC.title = destinationVC.category?.name
        }
        }
    
    // MARK: - Convinient Methods
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            fatalError("Saving problem, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }


}
