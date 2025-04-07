//
//  TaskCollectionViewCell.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "TaskCollectionViewCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var priorityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        priorityView.layer.cornerRadius = 4
    }
    
    func configure(with task: TaskModel) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        statusLabel.text = task.status.displayText
        
        switch task.priority {
        case .low:
            statusLabel.textColor           = task.priority.color
            priorityView.backgroundColor    = task.priority.color
        case .medium:
            statusLabel.textColor           = task.priority.color
            priorityView.backgroundColor    = task.priority.color
        case .high:
            statusLabel.textColor           = task.priority.color
            priorityView.backgroundColor    = task.priority.color
        }
    }
}
