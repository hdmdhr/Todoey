//
//  ViewController.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/3.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListVC: UITableViewController {
    let realm = try! Realm()
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var items: Results<Item>?
    var category : Category? {
        didSet{
            loadAllItems()  // load all the items under current category
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none  // 检查是否显示√
        } else {
            cell.textLabel?.text = "no item added yet"
        }
        return cell
    }

    // MARK: - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)   // 选中后一闪而过
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)                 // Delete realm
                    item.done = !item.done           // Update realm
                }
            } catch {
                fatalError("Error with saving item.done property, \(error)")
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Add New Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //MARK: 创建newItem，设置其parentCategory，储存至realm
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    self.category!.items.append(newItem)  // 设置relationship
                    self.realm.add(newItem)
                }
            } catch {
                fatalError("Error with writing data, \(error)")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField  // 创建一个指向alertTextField的共用var
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Convinient Methods
    
    func loadAllItems(){
            items = category?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
            tableView.reloadData()
        }

}



// MARK: - Search Bar Section

extension TodoListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
            }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {  // 动态检索
        if searchBar.text?.count == 0 {
            loadAllItems()
        } else {
            items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated")
            tableView.reloadData()
        }
    }
}

