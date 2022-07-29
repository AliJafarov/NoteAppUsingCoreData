//
//  NoteViewModel.swift
//  NoteApp
//
//  Created by Ali Jafarov on 23.07.22.
//

import Foundation

class NoteViewModel {
    
    var note: NotesItem?
    
    func getNoteData(id: UUID, completion: @escaping ()->() ){
        CoreDataManager.shared.getNote(with: id) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let note):
                    self.note = note
                    completion()
                case .failure(let error):
                    print(error)
            }
        }
    }
}
    
    

