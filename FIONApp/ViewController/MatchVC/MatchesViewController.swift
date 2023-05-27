//
//  MatchesViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import UIKit

final class MatchesViewController: UITableViewController {
    private enum Section {
        case main
    }
    
    private var userID: String
    private var userName: String
    private var matchManager = MatchesUIModel()
    
    private var datasource: UITableViewDiffableDataSource<Section, MatchObject>?
    
    init(userID: String, userName: String) {
        self.userID = userID
        self.userName = userName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.title = userName
        
        makeDatasource()
        fetchUserMatches()
    }
    
    func fetchUserMatches() {
        matchManager.fetchUserMatches(userID, completion: { [weak self] result in
            switch result {
            case .success(let matches):
                self?.applySnapshot(matches)
            case .failure(let error):
                self?.presentErrorAlert(message: error.localizedDescription)
            }
        })
    }
    
    private func applySnapshot(_ matches: [MatchObject]) {
        guard var snapshot = datasource?.snapshot() else { return }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(matches)
        
        datasource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - DataSource
extension MatchesViewController {
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: message,
                                                message: nil,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    func makeDatasource() {
        self.tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: MatchTableViewCell.identifier)
        
        datasource = UITableViewDiffableDataSource<Section, MatchObject>(tableView: self.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier) as? MatchTableViewCell else { return UITableViewCell() }
            
            cell.updateLabelText(itemIdentifier, target: self.userName)
            
            return cell
        })
        
        self.tableView.dataSource = datasource
    }
}
