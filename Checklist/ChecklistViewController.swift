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
    var tableData: [[CheckListItem?]?]! //потому что это полюбому заполним в viewDidload. структура массива состоит в том, что для каждой буквы в алфавите будет свой чеклист айтем, НА случай если не будет чеклист айтема с опредленной буквой для списка букв (а,б,в,г...), делаем optional
    
    @IBAction func addItem(_ sender: Any) {
        
        let newRowIndex = todoList.todos.count // новый индекс под номером = то кол-во элементов в массиве.(потому что кол-во элементов всегда +1 от кол-ва индексов). т е в данном случае newRowIndex = 5 - это индекс нашей будущей ячейки.
        _ = todoList.newTodo() // мы не будем использовать новый созданный айтэм. мы его просто создали и всё. i'm not interested in working with the object returned from this method.
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath] // создали новый эррэй с нашим индекспатсом [6,0] ОН ТАМ ОДИН.
        
        tableView.insertRows(at: indexPaths, with: .automatic) //вставили ячейки с массивом индексов, которые вверху. вместо indexPaths можно вставить [indexPath]. В ЭТОМ МАССИВЕ [indexPath] ОДИН ЭЛЕМЕНТ.
    }
    
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {// selectedRows - это выбранные ячейки типа [[0-section, 2-row], [0,4]]
            var items = [CheckListItem]() //массив чеклист айтемов, которые в конце удалим
            for indexPath in selectedRows {
                items.append(todoList.todos[indexPath.row]) //добавляем в массив из айтемов те айтемы, который выбрал юзер путем нажатия на круглешок.
            }
            todoList.remove(items: items) //ЭТО В МОДЕЛЕ.с помощью метода удаления, удаляем те айтемы, которые скопились в массиве сверху; это обновит нашу модель.
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
        
        let sectionTitleCount = UILocalizedIndexedCollation.current().sectionTitles.count //кол-во букв, используемые здесь
        var allSections = [[CheckListItem?]?](repeating: nil, count: sectionTitleCount) //инициализирует массив -[[CheckListItem?]?]. Это создаст 26 индивидуальных секций.
        var sectionNumber = 0 //изначально кол-во секций 0
        let collation = UILocalizedIndexedCollation.current()
        for item in todoList.todos {
            sectionNumber = collation.section(for: item, collationStringSelector: #selector(getter: CheckListItem.text))
            if allSections[sectionNumber] == nil { //проверяем представлен ли здесь массив.
                 allSections[sectionNumber] = [CheckListItem?]() //если нет, то создаем массив
            }
            allSections[sectionNumber]!.append(item) //assign it
        }
        tableData = allSections //assign it back to our table data
    }//ЭТО ИЗМЕНЯЕМ МОДЕЛЬ. вся эта херня сортирует всё в массивы(секции) (в алфавитном порядке по буквам видимо)
    
    override func setEditing(_ editing: Bool, animated: Bool) { // метод для редактирования????
        super.setEditing(editing, animated: true) //editing - так надо, не объясняется.
        tableView.setEditing(tableView.isEditing, animated: true)// y tableView есть метод isEditing.
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { //этот метод позволяет двигать РЯДЫ
        todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)//откуда и куда перемещаем
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section] == nil ? 0 : tableData[section]!.count //если нет , то вернем 0, если есть, то вернем кол-во секций
        
        //todoList.todos.count //подсчитать кол-во элем-ов в массиве, столько и будет рядов.(раньше было)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //этот метод вызывается каждый раз, когда тэйблвью нужна целл
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //let item = todoList.todos[indexPath.row]
        if let item = tableData[indexPath.section]?[indexPath.row] {
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
            let item = todoList.todos[indexPath.row]
            item.toggleChecked() // метод переключение галочки
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        todoList.todos.remove(at: indexPath.row) // удалили роу в индекс патс. индекс патс изменился, нужно его переназначить (строка ниже).
        let indexPaths = [indexPath] // tell table what we deleted. держим все возможные индекс патсы([], [], []) ОН ТАМ ОДИН! , которые были изменены верхней строчкой, в массиве. В ЭТОМ МАССИВЕ [indexPath] ОДИН ЭЛЕМЕНТ.
        tableView.deleteRows(at: indexPaths, with: .automatic) //удаляяем ячейки
        
        tableView.reloadData()
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
                    let indexPath = tableView.indexPath(for: cell) { //можем получить indexPath от tableView ячейки через cell выше. Мы узнали куда ткнул user.
                    let item = todoList.todos[indexPath.row] //get checklist item from todolist.
                    itemDetailViewController.itemToEdit = item //add item to itemDetailViewController and set it to property .itemToEdit. НЕ ПОНЯТНО!
                } // 1)get the item that is being edited from the "sender: Any?". Cast a sender to a type of tableViewCell.
                itemDetailViewController.delegate = self
                
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return tableData.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles //string of actual title of the section
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index) //сделать индекс каждой секции (0-25)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section] // буквы алфавита от A-Z
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {//update the checklist view controller to implement protocol
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true) //pop the view controller of the stack
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true) //pop the view controller of the stack
        //we need to become delegate of our AddItemTableViewController by using Segues:
        let rowIndex = todoList.todos.count - 1  //кол-во дел в нашем списке на данный момент
         //add checklist item to our todo list
        let indexPath = IndexPath(row: rowIndex, section: 0) //rowIndex - это например 6
        let indexPaths = [indexPath] // тогда [[6, 0]]
        tableView.insertRows(at: indexPaths, with: .automatic) //вставляем наш новый айтем в основной чеклиствьюконтроллер следующей строчкой.
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        if let index = todoList.todos.firstIndex(of: item) {//index айтема в модели ,например [6]
            let indexPath = IndexPath(row: index, section: 0) //например, [6,0]
            if let cell = tableView.cellForRow(at: indexPath) {// получить целл , которая на данном локейшне.
                configureText(for: cell, with: item) //метод изменения текста.
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

