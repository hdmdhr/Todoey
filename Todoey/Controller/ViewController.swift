//
//  ViewController.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/3.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    var defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Item()
        item1.title = "things to do 1"
        itemArray.append(item1)

        let item2 = Item()
        item2.title = "things to do 2"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "things to do 3"
        itemArray.append(item3)
        
        //MARK: Load data from database (persistence)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none  // 检查是否显示√
        
        return cell
    }

    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)   // 选中后一闪而过
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // 反向修改.done
        tableView.reloadData()
        
    }
    
    // MARK: - Add New Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")  // 储存数据
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField  // 创建一个指向alertTextField的共用var
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    

}

