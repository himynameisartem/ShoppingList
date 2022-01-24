//
//  ProductViewController.swift
//  ShoppingList
//
//  Created by Артем Кудрявцев on 21.01.2022.
//

import UIKit
import CoreData

class ProductViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    var productArray = [Item]()
    var titleBar = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleBar
//        loadItems()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        cell.textLabel?.text = productArray[indexPath.row].title
        cell.accessoryType = productArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, completion) in
            self.context.delete(self.productArray[indexPath.row])
            self.productArray.remove(at: indexPath.row)
            self.saveItems()
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productArray[indexPath.row].done = !productArray[indexPath.row].done
        saveItems()
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новый товар", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Сохранить", style: .default) { (alert) in
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.productArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Введите товар"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionaPredaicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionaPredaicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            productArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
}

extension ProductViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
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
