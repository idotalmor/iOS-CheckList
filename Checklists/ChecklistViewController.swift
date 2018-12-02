//
//  ViewController.swift
//  Checklists
//
//  Created by Ido Talmor on 26/11/2018.
//  Copyright © 2018 Ido Talmor. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let index = IndexPath(row: items.count, section: 0)//important to get index before inserting the new element
        items.append(item)
        tableView.insertRows(at: [index], with: .automatic)
        navigationController?.popViewController(animated: true)

    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //when moving to additem we need to set this ViewController as the delegate
    //the delegate is just a var that contains reference to an object that conform the custom protocol that we wrote, so we know that he must contain several methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            guard let dest = segue.destination as? ItemDetailViewController else{return}
            dest.delegate = self
        }
        else if segue.identifier == "EditItem"{
            
            guard let dest = segue.destination as? ItemDetailViewController else{return}
            dest.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
            dest.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    var items:[ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        do{
            
            let itemsURL = URL(fileURLWithPath: "items", relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("json")
            
            if let itemsData = try? Data(contentsOf: itemsURL){
                
                let jsonDecoder = JSONDecoder()
                if let itemsArray = try? jsonDecoder.decode([ChecklistItem].self, from: itemsData){
                    items = itemsArray
                }
                
            }
            
        }
        catch{
            print(error)
        }
                
        super.init(coder: aDecoder)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    func configureText(for cell:UITableViewCell, with item:ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell:UITableViewCell, with item:ChecklistItem){
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.isHidden = false
        } else {
            label.isHidden = true
        }
        
    }
    
    

    
}

