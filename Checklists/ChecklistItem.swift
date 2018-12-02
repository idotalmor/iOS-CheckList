//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ido Talmor on 26/11/2018.
//  Copyright © 2018 Ido Talmor. All rights reserved.
//

import UIKit

class ChecklistItem:NSObject,Codable{
    
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
}
