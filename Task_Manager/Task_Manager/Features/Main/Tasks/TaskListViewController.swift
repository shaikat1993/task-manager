//
//  TaskListViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit
import Combine

class TaskListViewController: BaseViewController<TaskListViewModel> {
    let cellId = TaskCollectionViewCell.identifier
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            // Create list configuration
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
//            config.showsSeparators = true
            config.backgroundColor = .systemBackground
            
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            collectionView.setCollectionViewLayout(layout, animated: false)
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: cellId,
                                          bundle: nil),
                                    forCellWithReuseIdentifier: cellId)
            collectionView.contentInset = UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: 0)
            
            
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
        viewModel.loadTasks()
    }
    
    private func setupNavigationBar() {
        title = "Tasks"
        navigationController?.setNavigationBarHidden(false,
                                                     animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(logoutTapped))
    }
    
    private func setupBindings() {
        viewModel.$tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    PPHUD.show()
                } else {
                    PPHUD.dismiss()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func logoutTapped() {
        viewModel.logout()
    }
}

extension TaskListViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! TaskCollectionViewCell
        let task = viewModel.tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        viewModel.selectTask(task)
    }
}
