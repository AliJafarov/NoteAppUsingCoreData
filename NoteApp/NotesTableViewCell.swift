//
//  NotesTableViewCell.swift
//  NoteApp
//
//  Created by Ali Jafarov on 23.07.22.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    static let reuseID = "NoteCell"
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func set (data: NotesItem?) {
        guard let data = data else {return}
        titleLabel.text = data.title ?? "No Title"
        dateLabel.text = data.date?.convertToMonthYearFormat()
    }
    
}
