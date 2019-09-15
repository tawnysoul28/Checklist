//
//  TodoList.swift
//  Checklist
//
//  Created by Bob on 12/08/2019.
//  Copyright © 2019 Bob. All rights reserved.
//

import Foundation

class TodoList {
    
    enum Priority: Int, CaseIterable { //CaseItirable - we can through all of the variable cases.(можно перебрать все переменные)
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [CheckListItem] = [] //делаем приватными, чтобы только TodoList класс имел к ним доступ.
    private var mediumPriorityTodos: [CheckListItem] = []
    private var lowPriorityTodos: [CheckListItem] = []
    private var noPriorityTodos: [CheckListItem] = []
    
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
        
        addTodo(row0Item, for: .low)
        addTodo(row1Item, for: .high)
        addTodo(row2Item, for: .medium)
        addTodo(row3Item, for: .high)
        addTodo(row4Item, for: .no)
    }
    
    
    func addTodo(_ item: CheckListItem, for priority: Priority, at index: Int = -1) { //удобный способ добавления нового элемента в чеклист. установили индекс -1(это когда пустой список), чтобы не сломать приложуху
        switch priority {
        case .high:
            if index < 0 {
            highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
                mediumPriorityTodos.insert(item, at: index)
            }
        case .low:
            if index < 0 {
                lowPriorityTodos.append(item)
            } else {
                lowPriorityTodos.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noPriorityTodos.append(item)
            } else {
                noPriorityTodos.insert(item, at: index)
            }
        }
    }
    
    func todoList(for priority: Priority) -> [CheckListItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }//на выходе список элементов
    
    func newTodo() -> CheckListItem {
        let item = CheckListItem()
        item.text = randomTitle()
        item.checked = true
        mediumPriorityTodos.append(item)//по дефолту все дела mediumPriorityTodos
        return item
    }
    
    func move(item: CheckListItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)
        
        
    }//берем айтем из предыдушей секции по индексу, вставляем в новую секцию по индексу
    
    func remove(_ item: CheckListItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }
    
//    func remove(items: [CheckListItem]) {//берем массив из чеклист айтемов, т.е. их местоположение [ [],[],[] ]
//        for item in items {
//            if let index = todos.firstIndex(of: item) {//todos.index(of: item) - берет индекс айтема, который находится в массиве сверху, например [0] (1ый элемент) или [3] (четвертый)
//                todos.remove(at: index) //убираем элемент(ячейку) по индексу
//            }
//        }
//    }
    
    private func randomTitle() -> String { //добавление рандомного заголовка в новую ячейку
        var titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
        let randomNumber = Int.random(in: 0 ... titles.count-1)
        
        return titles[randomNumber]
    }
}
