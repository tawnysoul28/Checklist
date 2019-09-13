//
//  TodoList.swift
//  Checklist
//
//  Created by Bob on 12/08/2019.
//  Copyright © 2019 Bob. All rights reserved.
//

import Foundation

class TodoList {
    
    var todos: [CheckListItem] = []
    
    init() {
        
        let row0Item = CheckListItem()
        let row1Item = CheckListItem()
        let row2Item = CheckListItem()
        let row3Item = CheckListItem()
        let row4Item = CheckListItem()
        
        row0Item.text = "Take a jog"
        row1Item.text = "Study design patterns"
        row2Item.text = "Walk the dog"
        row3Item.text = "Code an app"
        row4Item.text = "Watch a movie"
        
        todos.append(row0Item)
        todos.append(row1Item)
        todos.append(row2Item)
        todos.append(row3Item)
        todos.append(row4Item)
    }
    
    func newTodo() -> CheckListItem {
        let item = CheckListItem()
        item.text = randomTitle()
        item.checked = true
        todos.append(item)
        
        return item
    }
    
    func move(item: CheckListItem, to index: Int) { //берет чеклист айтем и индекс куда подвинуть айтем
        guard let currentIndex = todos.firstIndex(of: item) else { //index of - метод в который вставляем айтем. else если айтема там нет, то делаем ретерн
            return // теперь есть локация ОТКУДА И КУДА идет наш айтем.
        }
        todos.remove(at: currentIndex) //  убираем из текущего индекса
        todos.insert(item, at: index) // берем что? - Айтем и вставляем по индексу
    }
    
    func remove(items: [CheckListItem]) {//берем массив из чеклист айтемов, т.е. их местоположение [ [],[],[] ]
        for item in items {
            if let index = todos.firstIndex(of: item) {//todos.index(of: item) - берет индекс айтема, который находится в массиве сверху, например [0] (1ый элемент) или [3] (четвертый)
                todos.remove(at: index) //убираем элемент(ячейку) по индексу
            }
        }
    }
    
    private func randomTitle() -> String { //добавление рандомного заголовка в новую ячейку
        var titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
        let randomNumber = Int.random(in: 0 ... titles.count-1)
        
        return titles[randomNumber]
    }
}
