//
//  ViewController.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/3.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
//    var defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath ?? "abc")
        
//        hardCodedItems()
        
        //MARK: 在数据库中读取数据 (persistence)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items  }
        
        loadItems()
        
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
        saveItems()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //MARK: 储存itemArray中的数据
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
           self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField  // 创建一个指向alertTextField的共用var
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Convinient Methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error with encoding, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Decoding error, \(error)")
            }
        }
    }
    
    func hardCodedItems() {
        let item1 = Item()
        item1.title = "things to do 1"
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "things to do 2"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "things to do 3"
        itemArray.append(item3)
    }

}

