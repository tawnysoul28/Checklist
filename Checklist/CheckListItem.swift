//
//  CheckListItem.swift
//  Checklist
//
//  Created by Bob on 10/08/2019.
//  Copyright © 2019 Bob. All rights reserved.
//

import Foundation

class CheckListItem: NSObject { //represent To Do List Item (это первый Item) //появляется возможность сравнивнить мои items с другими items.
    
    @objc var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
}


