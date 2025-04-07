//
//  TaskDetailViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit
import Combine

class TaskDetailViewController: BaseViewController<TaskDetailViewModel> {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = .systemGroupedBackground
            
            // Remove extra spacing
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            
            // Remove content inset
            tableView.contentInset = .zero
            // Register cells
            tableView.register(UINib(nibName: TaskDetailInfoCell.infoCellId, bundle: nil),
                               forCellReuseIdentifier: TaskDetailInfoCell.infoCellId)
            tableView.register(UINib(nibName: TaskDetailStatusCell.statusCellId, bundle: nil),
                               forCellReuseIdentifier: TaskDetailStatusCell.statusCellId)
            tableView.register(UINib(nibName: TaskDetailDateCell.dateCellId, bundle: nil),
                               forCellReuseIdentifier: TaskDetailDateCell.dateCellId)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        // Do any additional setup after loading the view.
    }
    
    private func setupBindings() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - UITableViewDataSource
extension TaskDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, 
                   titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item {
        case .title(let title),
                .description(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailInfoCell.infoCellId,
                                                     for: indexPath) as! TaskDetailInfoCell
            cell.configure(with: title, 
                           isTitle: item.isTitle)
            return cell
            
        case .priority(_), 
             .status(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailStatusCell.statusCellId,
                                                     for: indexPath) as! TaskDetailStatusCell
            cell.configure(with: item)
            return cell
       
        case .dueDate(let date):
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailDateCell.dateCellId,
                                                     for: indexPath) as! TaskDetailDateCell
            cell.configure(with: date)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension TaskDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        switch item {
        case .description:
            return UITableView.automaticDimension
        default:
            return 72
        }
    }
}
