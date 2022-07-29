//
//  ViewController.swift
//  NoteApp
//
//  Created by Ali Jafarov on 23.07.22.
//

import UIKit

class NotesViewController: UIViewController {
    
    let notesVM = NotesViewModel()
    var searchController: UISearchController?
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.reuseID)
        return table
    }()
    
    var addNoteButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Add Note", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapAddNote), for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewDidLoad()
        configureButton()
        getNoteslist()
        settingSearchController()
        
    }
    
    private func getNoteslist(){
        notesVM.getNotes {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureViewDidLoad(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Notes"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
     
    }
    
    private func settingSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = "Search note"
        searchController?.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    private func configureButton(){
        view.addSubview(addNoteButton)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        
        addNoteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addNoteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    @objc private func didTapAddNote() {
        let vc = NoteFormController()
        vc.title = "Add New Note"
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
  
}



extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesVM.notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.reuseID, for: indexPath) as! NotesTableViewCell
        let notes = notesVM.notesArray[indexPath.row]
        cell.set(data: notes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notesVM.notesArray[indexPath.row]
        let vc = NoteViewController()
        vc.id = note.id
        self.navigationController?.pushViewController(vc, animated: true)
       }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = notesVM.notesArray[indexPath.row]
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, actionPerformed: (Bool) -> Void) in
            let vc = NoteFormController()
            vc.title = "Edit Your Note"
            vc.textField.text = note.title
            vc.textView.text = note.body
            vc.delegate = self
            vc.id = note.id
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
            actionPerformed(true)
          }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed: (Bool) -> Void) in

            let alertView = UIAlertController(title: "", message: "Are you sure you want to delete the note? ", preferredStyle: .alert)

                let deleteAction = UIAlertAction(title: "Delete", style: .default) { alert in
                    self.notesVM.deleteNotes(note: note) {
                    self.notesVM.notesArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.getNoteslist()
                    }
                }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertView.addAction(deleteAction)
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)

                    actionPerformed(true)
                }

        delete.image = UIImage(systemName: "trash")
        edit.image = UIImage(systemName: "square.and.pencil")
        edit.backgroundColor = .blue
       
        return UISwipeActionsConfiguration(actions: [delete, edit])
      }
}


extension NotesViewController: AddNoteViewControllerDelegate {
    func updateTableView() {
        getNoteslist()
    }
}

extension NotesViewController:  UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            notesVM.getsearchedNotes(searchText: searchText) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            getNoteslist()
        }
        
        
        
    }
    
    
    
    
    
}
