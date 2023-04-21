//
//  ViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import UIKit

class MainViewController: UIViewController {
    
    static let headerElementKind = "PlayerHeader"
    
    // MARK: - Properties
    private let modelManager = MainUIModel()
    
    private var datasource: UICollectionViewDiffableDataSource<PlayerSection, PlayerModel>?
    private var snapshot = NSDiffableDataSourceSnapshot<PlayerSection, PlayerModel>()
    
    // MARK: - UI Properties
    private var logoImageView = UIImageView()
    private var userTextField = UITextField()
    private var searchButton = UIButton(type: .roundedRect)
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        createDatasource()
        
        modelManager.fetchPlayerImages {
            DispatchQueue.main.async {
                let keeper = self.modelManager.playersCounter.values.sorted { $0.count > $1.count }.filter({ player in
                    return PlayerSection.goalkeeper.positionNumber.contains(player.position) && player.image != nil
                })
                let centerback = self.modelManager.playersCounter.values.sorted { $0.count > $1.count }.filter({ player in
                    return PlayerSection.centerback.positionNumber.contains(player.position) && player.image != nil
                })
                let sideback = self.modelManager.playersCounter.values.sorted { $0.count > $1.count }.filter({ player in
                    return PlayerSection.sideback.positionNumber.contains(player.position) && player.image != nil
                })
                let midfielder = self.modelManager.playersCounter.values.sorted { $0.count > $1.count }.filter({ player in
                    return PlayerSection.midfielder.positionNumber.contains(player.position) && player.image != nil
                })
                let winger = self.modelManager.playersCounter.values.sorted { $0.count > $1.count }.filter({ player in
                    return PlayerSection.winger.positionNumber.contains(player.position) && player.image != nil
                })
                let striker = self.modelManager.playersCounter.values.sorted { $0.count > $1.count }.filter({ player in
                    return PlayerSection.striker.positionNumber.contains(player.position) && player.image != nil
                })
                
                self.applySnapshot(by: .goalkeeper, to: keeper)
                self.applySnapshot(by: .centerback, to: centerback)
                self.applySnapshot(by: .sideback, to: sideback)
                self.applySnapshot(by: .midfielder, to: midfielder)
                self.applySnapshot(by: .winger, to: winger)
                self.applySnapshot(by: .striker, to: striker)
            }
        }
    }
    
    @objc func didTapSearchButton() {
        guard let nickname = self.userTextField.text else { return }
        
        let contentType = ContentType.userInfo(nickname: nickname)
        let networkModel = NetworkManager(type: contentType)
        
        modelManager.fetchUserDataByJson(manager: networkModel, UserInfoObject.self) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let matchesVC = MatchesViewController(style: .insetGrouped)
                    
                    matchesVC.userName = data.name
                    matchesVC.userID = data.userId
                    
                    self?.navigationController?.pushViewController(matchesVC, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentErrorAlert(message: error.localizedDescription)
                }
            }
        }
    } 
}

extension MainViewController {
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(3), top: .none, trailing: .fixed(3), bottom: .none)
        
        let headerViewSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerViewSize, elementKind: MainViewController.headerElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createDatasource() {
        guard let collectionView = self.collectionView else { return }
        
        let cellRegistration = UICollectionView.CellRegistration<PlayerImageCell, PlayerModel> { cell, indexPath, itemIdentifier in
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            
            cell.updateUI(itemIdentifier)
        }
        
        datasource = UICollectionViewDiffableDataSource<PlayerSection, PlayerModel>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    private func applySnapshot(by section: PlayerSection, to model: [PlayerModel]) {
        snapshot.appendSections([section])
        snapshot.appendItems(model)
        
        self.datasource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UI
extension MainViewController {
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: message,
                                                message: nil,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground
        
        configureLogoImageView()
        configureUserTextField()
        configureSearchButton()
        configureCollectionView()
    }
    
    private func configureLogoImageView() {
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.contentMode = .scaleAspectFill
        self.logoImageView.image = Bundle.main.logo
        self.logoImageView.clipsToBounds = true
        
        self.view.addSubview(self.logoImageView)
        
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.logoImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func configureUserTextField() {
        self.userTextField.translatesAutoresizingMaskIntoConstraints = false
        self.userTextField.borderStyle = .roundedRect
        self.userTextField.backgroundColor = .systemGray
        self.userTextField.textColor = .systemGreen
        
        let attributedOption: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let placeholderText = NSAttributedString(string: "유저 닉네임을 입력해주세요", attributes: attributedOption)
        
        self.userTextField.attributedPlaceholder = placeholderText
        
        self.view.addSubview(self.userTextField)
        
        NSLayoutConstraint.activate([
            self.userTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 10),
            self.userTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }
    
    private func configureSearchButton() {
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.setTitle("검색", for: .normal)
        self.searchButton.layer.cornerRadius = 4
        self.searchButton.backgroundColor = .systemBlue
        self.searchButton.tintColor = .white
        
        self.view.addSubview(self.searchButton)
        
        NSLayoutConstraint.activate([
            self.searchButton.centerYAnchor.constraint(equalTo: self.userTextField.centerYAnchor),
            self.searchButton.widthAnchor.constraint(equalTo: self.userTextField.widthAnchor, multiplier: 0.25),
            self.searchButton.leadingAnchor.constraint(equalTo: self.userTextField.trailingAnchor, constant: 10),
            self.searchButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        self.searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.userTextField.bottomAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.collectionView = collectionView
    }
}
