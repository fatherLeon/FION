//
//  MatchesViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import UIKit

class MatchesViewController: UITableViewController {
    
    var userID: String = ""
    var userName: String = ""
    
    private var userMatchesManager: NetworkManager<UserMatchObject>? = nil
    private var matchManager: MatchManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = userName
        
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: MatchTableViewCell.identifier)
        
        fetchUserMatches()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .matchesInfo, object: nil)
    }
    
    @objc private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchUserMatches() {
        userMatchesManager = NetworkManager(type: .userMatch(id: "\(userID)", matchType: 50, limit: 20))
        
        userMatchesManager?.fetchDataByJson(handler: { [weak self] result in
            switch result {
            case .success(let data):
                self?.matchManager = MatchManager(matchIds: data.matchIds)
                self?.matchManager?.fetchMatchInfo()
            case .failure(let error):
                print(error)
            }
        })
    }
}

// MARK: - DataSource
extension MatchesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = matchManager?.matchesInfo.count else { return 0 }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier, for: indexPath) as? MatchTableViewCell,
              let data = self.matchManager?.matchesInfo[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.updateLabelText(data, target: userName)
        
        return cell
    }
}
