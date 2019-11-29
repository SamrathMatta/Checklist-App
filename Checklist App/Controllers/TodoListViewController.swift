//
//  ViewController.swift
//  Checklist App
//
//  Created by Samrath Matta on 11/12/19.
//  Copyright © 2019 Samrath Matta. All rights reserved.
//

 import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItem : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadItems()
  
    }
    
    // MARK - TableView Datasource Methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier : "ToDoItemCell", for: indexPath)
       
        if let item = todoItem?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    }
            } catch {
                print("Error saving done status, \(error)")
                }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    

    @IBAction func addButtonPressedItems(_ sender: UIBarButtonItem) {
        
          var textfield = UITextField()
            
            let alert = UIAlertController(title: "Add New Checklist Item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textfield.text!
                            currentCategory.items.append(newItem)
                }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
                
                self.tableView.reloadData()
                
        }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textfield = alertTextField
                
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    // MARK - Model Manupulation Methods
    
    

    func loadItems() {
        
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
    


//MARK: - Search Bar Methods



extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }



        }
    }


}
