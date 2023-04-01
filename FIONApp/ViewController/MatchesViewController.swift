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
    private var matchesData: [MatchObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = userName
        
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: MatchTableViewCell.identifier)
        
        fetchUserMatches()
    }
    
    func fetchUserMatches() {
        userMatchesManager = NetworkManager(type: .userMatch(id: "\(userID)", matchType: 50, limit: 10))
        
        userMatchesManager?.fetchDataByJson(handler: { [weak self] result in
            switch result {
            case .success(let data):
                self?.matches = data.matchIds
                self?.fetchMatch()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchMatch() {
        self.matches.forEach { matchid in
            matchManager = NetworkManager(type: .match(matchid: matchid))
            
            matchManager?.fetchDataByJson(handler: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.matchesData.append(data)
                case .failure(let error):
                    print("matchData - \(error)")
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier, for: indexPath) as? MatchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateLabelText(self.matchesData[indexPath.row])
        
        return cell
    }
}
