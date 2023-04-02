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
    private var matches: [String] = ["63f18d93e982f639cfe3822c"]
    private var matchesData: [MatchObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = userName
        
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: MatchTableViewCell.identifier)
        
        fetchUserMatches()
    }
    
    func fetchUserMatches() {
        userMatchesManager = NetworkManager(type: .userMatch(id: "\(userID)", matchType: 50, limit: 5))
        
        userMatchesManager?.fetchDataByJson(handler: { [weak self] result in
            switch result {
            case .success(let data):
                self?.matchManager = MatchManager(matchIds: data.matchIds)
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
        return matchesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier, for: indexPath) as? MatchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateLabelText(self.matchesData[indexPath.row])
        
        return cell
    }
}
