//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/7.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = Array<Category>()
    
    //MARK: 获得run time时的view.Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: 读取数据
        loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    

    
    
    // MARK: - Add New Categories
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create a New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // creat, append, save data, reload table
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text ?? "default category"
            self.saveCategory()
            self.loadCategory()
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
            destinationVC.category = categories[tableView.indexPathForSelectedRow!.row]
            destinationVC.title = destinationVC.category?.name
        }
        
        
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Convinient Methods
    func saveCategory(){
        do {
            try context.save()
        } catch {
            fatalError("Saving problem, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            fatalError("Reading data failed, \(error)")
        }
        tableView.reloadData()
    }


}
