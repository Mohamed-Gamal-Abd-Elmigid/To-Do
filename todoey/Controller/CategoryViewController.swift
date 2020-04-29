//
//  CategoryViewController.swift
//  Todoey
//
//  Created by mac on 4/24/20.
//  Copyright © 2020 ASD. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
class CategoryViewController: UITableViewController
{
     let realm = try! Realm()
    
    var categories : Results<Category>?
     var tf = UITextField ()
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()
        
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
   
      cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Add"

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{ // indexpath
        destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }


    func saveCategory(category : Category) {
        do{ 
            
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error")
        }
        self.tableView.reloadData()
    }
//with request : NSFetchRequest<Category> = Category.fetchRequest()
    func loadCategories()  {
        
      categories = realm.objects(Category.self)
        
//    let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do{
//            categories =  try context.fetch(request)
//        }catch{
//           print("error")
//    }
            tableView.reloadData()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        let alert =  UIAlertController(title: "add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default ){(action)in
            let newCategory = Category()
            newCategory.name = self.tf.text!
        
            self.saveCategory(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField {(field ) in
            self.tf = field
            self.tf.placeholder = "add new Category"
        }
        present(alert,animated: true,completion:nil)
    }
}
