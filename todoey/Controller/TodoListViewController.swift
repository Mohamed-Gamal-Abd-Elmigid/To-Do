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

class TodoListViewController: UITableViewController  , UISearchBarDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate{
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
          loadItems() // load data ellli 5asa b category dh
        }
    }
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     //   .first?.appendingPathComponent("items.plist")// lel documention
//    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    //ll coreData
   // let defaults = UserDefaults.standard
    // dh ll 7agat el basita m4 object
   var tf = UITextField()
    var tf2 = UITextField()

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
      //  loadItems()

    }
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let edit = editAction(at:indexPath)
//        let delete = deleteAction(at:indexPath)
//        return UISwipeActionsConfiguration(actions: [delete,edit])
//    }
//    func editAction(at indexPath:IndexPath) -> UIContextualAction {
//
//        let action = UIContextualAction(style: .normal, title: "edit"){
//            (action,view,completion )in
//
//           self.todoItems[indexPath.row].setValue("self.tf2", forKey: "title")
//
//            self.saveItem()
//            completion(true)
//        }
//        action.image = UIImage (named: "edit")
//        action.backgroundColor = .green
//        return action
//    }
//    func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .destructive, title: "Delete"){
//            (action,view,completion )in
//
//         //   self.context.delete(self.itemArray[indexPath.row])//mohm gdn ashilo mn context el awel
//              self.todoItems.remove(at: indexPath.row)
//            self.saveItem()
//            completion(true)
//        }
//        action.image = UIImage (named: "delete")
//        action.backgroundColor = .red
//        return action
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = todoItems?[indexPath.row].title
        if todoItems?[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        }
        else
        {
            cell.textLabel?.text = "No Item Added "
        }
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
      
//        if todoItems[indexPath.row].done == false {
//            todoItems[indexPath.row].done = true
//        } else {
//            todoItems[indexPath.row].done = false
//        }
       // self.saveItem()
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
//    func saveItem()  {
//
//
//        do{
//
//          try context.save()
//        }
//        catch{
//            print("error")
//        }
//         self.tableView.reloadData()
//    }
    func loadItems()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){ //read data mn Coredata
//        // el code eli gai 34an lma ydos 3la category ytal3 el item bt3to mn 3'iro hytl3 kol item
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate]) // load data elli mawgoda w elli htadaf
//        }else{
//             request.predicate = categoryPredicate // load data elli mawgoda
//        }
//     // let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do{
//           itemArray =  try context.fetch(request) // bagib data mn context
//        }catch{
//            print("error")
//        }
     //   tableView.reloadData()
   // }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {//  dh search
            
    todoItems = todoItems?.filter("title CONTAINS[cd] %@    ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
        
//        let request :  NSFetchRequest<Item> = Item.fetchRequest()
//
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request,predicate: predicate)
//    tableView.reloadData()
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
}

