//
//  CoreDataManager.swift
//  NoteApp
//
//  Created by Ali Jafarov on 28.07.22.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func addNote(title: String?, body: String? , completion: @escaping ()->()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NotesItem", in: context)
        let noteItem = NotesItem(entity: entity!, insertInto: context)
        noteItem.title = title
        noteItem.body = body
        noteItem.date = Date()
        noteItem.id = UUID()
        do {
            try context.save()
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getNotes(completion: @escaping(Result<[NotesItem], Error >) -> Void) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<NotesItem> = NotesItem.fetchRequest()
            do {
                let notes = try context.fetch(request)
                completion(.success(notes))
            } catch {
                completion(.failure(error))
            }
        }
    
    func getNote(with id: UUID?, completion: @escaping (Result<NotesItem, Error>) -> Void )  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let id = id else { return }
 
        let request: NSFetchRequest<NotesItem> = NotesItem.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let note = try? context.fetch(request) else { return }
        completion(.success(note.first!))
         
    }
    
    func upDateNote(title: String?, body: String?, id: UUID, date: Date, completion: @escaping ()->()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<NotesItem> = NotesItem.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
            
        
        do {
            let  result = try context.fetch(request)
            let managedObject = result[0]
                managedObject.setValue(title, forKey: "title")
                managedObject.setValue(body, forKey: "body")
                managedObject.setValue(date, forKey: "date")
            try context.save()
            completion()
        } catch {
            print(error)
        }
    }
    
    func deleteNote(note: NotesItem, completion: @escaping ()->()){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(note)
        do {
            try context.save()
            completion()
        } catch {
            print(error)
        }
    }
    
    func searchNote(searchText: String, completion: @escaping(Result<[NotesItem], Error >) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<NotesItem> = NotesItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchText)
        
        do {
            let result = try context.fetch(request)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
