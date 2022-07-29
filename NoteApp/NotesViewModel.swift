//
//  NotesViewModel.swift
//  NoteApp
//
//  Created by Ali Jafarov on 23.07.22.
//

import UIKit

class NotesViewModel {
    
    var notesArray: [NotesItem] = []
    
    func getNotes(completion: @escaping ()->()){
        CoreDataManager.shared.getNotes { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let notes):
                    self.notesArray = notes
                    completion()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func deleteNotes(note: NotesItem, completion: @escaping ()->() ){
        CoreDataManager.shared.deleteNote(note: note) {
            completion()
        }
    }
    
    func getsearchedNotes(searchText: String, completion: @escaping ()->()) {
        CoreDataManager.shared.searchNote(searchText: searchText) { [weak self] result in
            switch result {
            case .success(let notes):
                self?.notesArray = notes
                completion()
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
}
