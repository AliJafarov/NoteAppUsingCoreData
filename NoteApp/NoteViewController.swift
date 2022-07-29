//
//  NoteViewController.swift
//  NoteApp
//
//  Created by Ali Jafarov on 23.07.22.
//

import UIKit

class NoteViewController: UIViewController {
    
    var noteVM = NoteViewModel()
    var id: UUID?
    private var dateText: Date?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        getData()
        
    }

    private func getData(){
        noteVM.getNoteData(id: id!) {
            DispatchQueue.main.async {
                
                
                self.titleLabel.text = self.noteVM.note?.title
                self.bodyLabel.text = self.noteVM.note?.body
                self.dateLabel.text = self.noteVM.note?.date?.convertToMonthYearFormat()
            }
        }
    }
    
    private func configureLabels () {
        
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(dateLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true

        
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
    }
    

}
