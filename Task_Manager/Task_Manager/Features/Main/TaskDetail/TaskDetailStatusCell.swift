//
//  TaskDetailStatusCell.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit

class TaskDetailStatusCell: UITableViewCell {
    static let statusCellId = "TaskDetailStatusCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: TaskDetailItem) {
            switch item {
            case .priority(let priority):
                titleLabel.text = "Priority"
                valueLabel.text = priority.displayText
                switch priority {
                case .low:
                    indicatorView.backgroundColor = .systemGreen
                case .medium:
                    indicatorView.backgroundColor = .systemYellow
                case .high:
                    indicatorView.backgroundColor = .systemRed
                }
                
            case .status(let status):
                titleLabel.text = "Status"
                valueLabel.text = status.displayText
                switch status {
                case .todo:
                    indicatorView.backgroundColor = .systemGray
                case .inProgress:
                    indicatorView.backgroundColor = .systemBlue
                case .done:
                    indicatorView.backgroundColor = .systemGreen
                }
                
            default:
                break
            }
        }
}
