//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Ido Talmor on 27/11/2018.
//  Copyright © 2018 Ido Talmor. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class{
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item:ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item:ChecklistItem)
}


class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    var itemToEdit:ChecklistItem?
    
    weak var delegate:ItemDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textField.delegate = self
        
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    @IBAction func Cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func Done(){
        if let itemToEdit = itemToEdit{
            itemToEdit.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAdding: item)}
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range,in:oldText)
        let newText = oldText.replacingCharacters(in: stringRange!, with: string)
        if newText.isEmpty{
            doneBarButton.isEnabled = false
        }else{
            doneBarButton.isEnabled = true
        }
        return true
    }
    
}
