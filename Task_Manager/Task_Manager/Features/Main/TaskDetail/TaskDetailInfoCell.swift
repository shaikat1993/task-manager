//
//  TaskDetailInfoCell.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit

class TaskDetailInfoCell: UITableViewCell {
    static let infoCellId = "TaskDetailInfoCell"
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with text: String, isTitle: Bool) {
        titleLabel.text = text
        titleLabel.font = isTitle ? .systemFont(ofSize: 18, weight: .semibold) : .systemFont(ofSize: 16)
        titleLabel.numberOfLines = isTitle ? 1 : 0
    }
}
