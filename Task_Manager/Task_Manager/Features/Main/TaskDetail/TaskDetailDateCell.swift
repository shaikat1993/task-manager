//
//  TaskDetailDateCell.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit

class TaskDetailDateCell: UITableViewCell {
    static let dateCellId = "TaskDetailDateCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with date: Date) {
        titleLabel.text = "Due Date"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: date)
    }
}
