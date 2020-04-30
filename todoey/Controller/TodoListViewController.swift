//
//  ViewController.swift
//  Todoey
//
//  Created by mac on 3/10/20.
//  Copyright © 2020 ASD. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: UITableViewController  , UISearchBarDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate , SwipeTableViewCellDelegate
{
    var todoItems : Results<Item>?
    
    
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
          loadItems() // load data ellli 5asa b category dh
        }
    }
    var tf = UITextField()
    var tf2 = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
      //  loadItems()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none

        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            {
                cell.backgroundColor = color
             // cell.textLabel?.textColor = ContrastColorOf(color , returnFlat : true)
            }
        }
        else{ cell.textLabel?.text = "No Items Add"
            cell.textLabel?.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        }
        cell.textLabel?.textColor = UIColor.white
        cell.delegate = self
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]
        {
            do
            {
                try realm.write
                {
                    item.done = !item.done
                }
            }
            catch
            {
                print("Error in Check Itemi ")
            }
        }
      

        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    @IBAction func addbutton(_ sender: UIBarButtonItem) {
        let alert =  UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default ){(action)in
            
//          //  let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            if let currentCategory = self.selectedCategory
            {   do
            {
                try self.realm.write
                {
                let newItem = Item()
                newItem.title = self.tf.text!
                newItem.done = false
                currentCategory.items.append(newItem)
                }
                }
                catch
                {
                    print("Error Saving Items \(error)")
                }
               
            }
            self.tableView.reloadData()
  }
        alert.addTextField{(alertTextField)in
            alertTextField.placeholder = "create new item"
            self.tf =  alertTextField
        }
        alert.addAction(action)
        present (alert, animated: true,completion: nil)
    }

    func loadItems()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {//  dh search
            
    todoItems = todoItems?.filter("title CONTAINS[cd] %@    ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
        
 }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {//34an lma myob2a4 fih 7arf f search
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async
                { // satr dh 34an el cursur y5tafi

              searchBar.resignFirstResponder()

            }        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
        {
          guard orientation == .right else { return nil }

          let deleteAction = SwipeAction(style: .destructive, title: "Delete")
          { action, indexPath in
              // handle action by updating model with deletion
              if let itemForDelection = self.todoItems?[indexPath.row]
              {
                   do {
                      try  self.realm.write{
                            try  self.realm.delete(itemForDelection)
                                          }
                   }
                  catch
                          {
                              print("Error in Deleing Category \(error.localizedDescription)")
                          }
                  }
            }
          deleteAction.image = UIImage(named: "delete")
          return [deleteAction]
          

      }
          func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
              var options = SwipeOptions()
              options.expansionStyle = .destructive
              options.transitionStyle = .border
              return options
          }

}

