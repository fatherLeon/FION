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
    private var matchManager: NetworkManager<MatchObject>? = nil
    private var matches: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = userName
        
        fetchUserMatches()
    }
    
    func fetchUserMatches() {
        userMatchesManager = NetworkManager(type: .userMatch(id: "\(userID)", matchType: 50, limit: 10))
        
        userMatchesManager?.fetchDataByJson(handler: { [weak self] result in
            switch result {
            case .success(let data):
                self?.matches = data.matchIds
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchMatch(matchid: String) {
        matchManager = NetworkManager(type: .match(matchid: matchid))
    }
}


// MARK: - DataSource
extension MatchesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matches.count
    }
}
