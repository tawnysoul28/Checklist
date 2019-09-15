//
//  ViewController.swift
//  Checklist
//
//  Created by Bob on 31/07/2019.
//  Copyright © 2019 Bob. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var todoList: TodoList
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? { //переводит число индекса в енум, который в TodoList лежит
        return TodoList.Priority(rawValue: index)
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        let newRowIndex = todoList.todoList(for: .medium).count // новый индекс под номером = то кол-во элементов в массиве.(потому что кол-во элементов всегда +1 от кол-ва индексов). т е в данном случае newRowIndex = 5 - это индекс нашей будущей ячейки. автоматом в .medium
        _ = todoList.newTodo() // мы не будем использовать новый созданный айтэм. мы его просто создали и всё. i'm not interested in working with the object returned from this method.
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath] // создали новый эррэй с нашим индекспатсом [6,0] ОН ТАМ ОДИН.
        
        tableView.insertRows(at: indexPaths, with: .automatic) //вставили ячейки с массивом индексов, которые вверху. вместо indexPaths можно вставить [indexPath]. В ЭТОМ МАССИВЕ [indexPath] ОДИН ЭЛЕМЕНТ.
    }
    
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {// selectedRows - это выбранные ячейки типа [[0-section, 2-row], [0,4]]
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList.todoList(for: priority)
                    
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete] //добавляем в массив из айтемов те айтемы, который выбрал юзер путем нажатия на круглешок.
                    todoList.remove(item, from: priority, at: rowToDelete)//ЭТО В МОДЕЛЕ.с помощью метода удаления, удаляем те айтемы, которые скопились в массиве сверху; это обновит нашу модель.
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)//ЭТО В ТЭЙБЛВЬЮ. удаляем выбранные rows.
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) { //this is called when view controller is initialized from a storyboard ???
        // ЗДЕСЬ ИДЕТ РАБОТА С MODEL !
        todoList = TodoList()
        super.init(coder: aDecoder) // переписываем уже существующий метод, который лежит в NSCoder под свои предпочтения.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true //изменяем в навигейшн контроллере размер текста
        navigationItem.leftBarButtonItem = editButtonItem//этими заклинаниями вставили в верхний левый угол Edit кнопку
        tableView.allowsMultipleSelectionDuringEditing = true //разрешаем выделять несколько rows во время редактирования
        
    }//ЭТО ИЗМЕНЯЕМ МОДЕЛЬ. вся эта херня сортирует всё в массивы(секции) (в алфавитном порядке по буквам видимо)
    
    override func setEditing(_ editing: Bool, animated: Bool) { // метод для редактирования????
        super.setEditing(editing, animated: true) //editing - так надо, не объясняется.
        tableView.setEditing(tableView.isEditing, animated: true)// y tableView есть метод isEditing.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count //если нет , то вернем 0, если есть, то вернем кол-во секций
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //этот метод вызывается каждый раз, когда тэйблвью нужна целл
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //let item = todoList.todos[indexPath.row]
        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList.todoList(for: priority) // список айтемов
            let item = items[indexPath.row] // айтем из списка
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
       
    return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { //игнорируем тапы от пользователей, чтобы не возникало перехватов при нажатии галочек
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) { //возьмет ячейку по индекс патсу
            if let priority = priorityForSectionIndex(indexPath.section) {
                let items = todoList.todoList(for: priority)
                let item = items[indexPath.row]
                item.toggleChecked() // метод переключение галочки
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(item, from: priority, at: indexPath.row) // удалили роу в индекс патс. индекс патс изменился, нужно его переназначить (строка ниже).
            let indexPaths = [indexPath] // tell table what we deleted. держим все возможные индекс патсы([], [], []) ОН ТАМ ОДИН! , которые были изменены верхней строчкой, в массиве. В ЭТОМ МАССИВЕ [indexPath] ОДИН ЭЛЕМЕНТ.
            tableView.deleteRows(at: indexPaths, with: .automatic) //удаляяем ячейки
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { //этот метод позволяет двигать РЯДЫ
        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
           let destPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
        }
        tableView.reloadData() //важная штука, которая сразу же обновляет всю вью и дату после перемещения дела в другую секцию.
    }
    
    func configureText(for cell: UITableViewCell, with item: CheckListItem) { // изменение текста в ячейке
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text //присвоили ячейке с лейблом текст оперделенного айтема
        }
    }

    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem) { // изменение галочек
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = "√"
        } else {
            checkmarkCell.checkmarkLabel.text  = ""
          }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {// в этой переменной itemDetailViewController хранится путь до AddItemTableViewController.
                itemDetailViewController.delegate = self //access a delegate property. НЕ ПОНЯТНО.
                itemDetailViewController.todoList = todoList //our model object. НЕ ПОНЯТНО.
            }
        } else if segue.identifier == "EditItemSegue" { //setup our EditItem segue
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell, //кастим через Sender ячейку до ТейблВью цел.
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section)
                    { //можем получить indexPath от tableView ячейки через cell выше. Мы узнали куда ткнул user.
                        
                    let item = todoList.todoList(for: priority)[indexPath.row] //get checklist item from todolist.
                    itemDetailViewController.itemToEdit = item //add item to itemDetailViewController and set it to property .itemToEdit. НЕ ПОНЯТНО!
                } // 1)get the item that is being edited from the "sender: Any?". Cast a sender to a type of tableViewCell.
                itemDetailViewController.delegate = self
                
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return TodoList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { 
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority Todos"
            case .medium:
                title = "Medium Priority Todos"
            case .low:
                title = "Low Priority Todos"
            case .no:
                title = "Someday Todo Items"
            }
        }
        return title
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {//update the checklist view controller to implement protocol
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true) //pop the view controller of the stack
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true) //pop the view controller of the stack
        //we need to become delegate of our AddItemTableViewController by using Segues:
        let rowIndex = todoList.todoList(for: .medium).count - 1  //кол-во дел в нашем списке на данный момент
         //add checklist item to our todo list
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue) //rowIndex - это например 6
        let indexPaths = [indexPath] // тогда [[6, 0]]
        tableView.insertRows(at: indexPaths, with: .automatic) //вставляем наш новый айтем в основной чеклиствьюконтроллер следующей строчкой.
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.firstIndex(of: item) { //проверяем есть ли айтем в массиве, если есть, то возвращаем его индекс
                let indexPath = IndexPath(row: index, section: priority.rawValue) //например, [6,0]. путь к индексу в зависимости от секции
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item) //метод изменения текста.
                }
                
            }
        } //узнать в каком прайорити находятся айтемы из чеклиста
        navigationController?.popViewController(animated: true)
    }
}

