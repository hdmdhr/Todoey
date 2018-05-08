//
//  ViewController.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/3.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var itemArray = [Item]()
    var category : Category? {
        didSet{
            loadItems()  // load all the items under current category
        }
    }
    
    //MARK: 获得run time时的view.Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //MARK: 在数据库中读取数据 (persistence)
    }
    
    //MARK: - Tableview Datasource
    
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

    // MARK: - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)   // 选中后一闪而过
        
//        context.delete(itemArray[indexPath.row])  // 删除context中的数据，顺序很重要！
//        itemArray.remove(at: indexPath.row)  // 删除itemArray中的数据
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // 反向修改.done
        
        //MARK: 将修改过.done的数据储存至数据库  ???为什么itemArray可以没有context情况下储存
        saveItems()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.category
            self.itemArray.append(newItem)  // 和数据库无关，仅更新表格内容itemArray
            
            //MARK: 储存context中的数据
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
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)         // ALWAYS load data under category!!!

        if predicate != nil {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
            do {
                itemArray = try context.fetch(request)
            } catch {
                fatalError("Error fetching data, \(error)")
            }
            tableView.reloadData()
        }

}



// MARK: - Search Bar Section

extension TodoListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {  // 动态检索
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate)
        
        if searchBar.text?.count == 0 {
            loadItems()
        }
    }
}



