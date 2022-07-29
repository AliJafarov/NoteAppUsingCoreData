//
//  AddNoteViewController.swift
//  NoteApp
//
//  Created by Ali Jafarov on 23.07.22.
//

import UIKit

protocol AddNoteViewControllerDelegate: AnyObject {
    func updateTableView()
}

class NoteFormController: UIViewController {
    
    var id: UUID?
    var date: Date = Date()
    weak var delegate: AddNoteViewControllerDelegate?
    
    var textFieldCheckLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .red
        return label
    }()
    
    var textViewCheckLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .red
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Title"
        textField.returnKeyType = .done
        textField.autocapitalizationType = .words
        return textField
    }()
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.backgroundColor = .secondarySystemBackground
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 20
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        textView.layer.shadowColor = UIColor.gray.cgColor;
        textView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        textView.layer.shadowOpacity = 0.4
        textView.layer.shadowRadius = 2
        textView.layer.masksToBounds = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDidload()
        configureTextViewAndFieldAndLabels()
        dismissKeyboard()
    }
    
    private func configureDidload(){
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureTextViewAndFieldAndLabels(){
        view.addSubview(textField)
        view.addSubview(textView)
        view.addSubview(textFieldCheckLabel)
        view.addSubview(textViewCheckLabel)
        textField.delegate = self
        textView.delegate = self
       
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textFieldCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        textViewCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 60).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        textFieldCheckLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        textFieldCheckLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
        
        textViewCheckLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
        textViewCheckLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
        
        
    }
    
   private func dismissKeyboard() {
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        }
    
    @objc private func didTapSave() {
        
        textFieldCheckLabel.isHidden = true
        textViewCheckLabel.isHidden = true
        
        if id != nil{
            CoreDataManager.shared.upDateNote(title: textField.text, body: textView.text, id: self.id!, date: date) {
                self.delegate?.updateTableView()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if textField.text != "" && textView.text != "" {
                CoreDataManager.shared.addNote(title: textField.text, body: textView.text) {
                    self.delegate?.updateTableView()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                if textField.text?.isEmpty ?? true {
                    textFieldCheckLabel.text = "Name couldn't be empty"
                    DispatchQueue.main.async {
                        UIView.transition(with: self.textFieldCheckLabel, duration: 0.6, options: .curveEaseOut, animations: {
                            self.textFieldCheckLabel.isHidden = false
                        })
                    }
                }
                if textView.text?.isEmpty ?? true {
                    textViewCheckLabel.text = "You haven't yet added any note"
                    DispatchQueue.main.async {
                        UIView.transition(with: self.textViewCheckLabel, duration: 0.6, options: .curveEaseOut, animations: {
                            self.textViewCheckLabel.isHidden = false
                        })
                    }
                }
            }
        }
    }
}

extension NoteFormController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            UIView.transition(with: self.textFieldCheckLabel, duration: 0.6, options: .curveEaseIn, animations: {
                self.textFieldCheckLabel.isHidden = true
            })
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            UIView.transition(with: self.textFieldCheckLabel, duration: 0.6, options: .curveEaseIn, animations: {
                self.textViewCheckLabel.isHidden = true
            })
        }
    }
}
