//
//  ViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import UIKit

class MainViewController: UIViewController {
    
    enum PlayerSection: CaseIterable {
        case goalkeeper
        case defender
        case midfielder
        case striker
    }
    
    // MARK: - Properties
    private let modelManager = MainUIModel()
    
    private var datasource: UICollectionViewDiffableDataSource<PlayerSection, UIImage>?
    private var snapshot = NSDiffableDataSourceSnapshot<PlayerSection, UIImage>()
    
    // MARK: - UI Properties
    private var logoImageView = UIImageView()
    private var userTextField = UITextField()
    private var searchButton = UIButton(type: .roundedRect)
    private var collectionView: UICollectionView?
    private var loadingView = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        createDatasource()
        
        modelManager.fetchPlayerImages {
            DispatchQueue.main.async {
                let keeper = Array(self.modelManager.playerImages[0...5])
                let defender = Array(self.modelManager.playerImages[6...10])
                let midfielder = Array(self.modelManager.playerImages[11...15])
                let striker = Array(self.modelManager.playerImages[20...24])
                
                self.applySnapshot(by: .goalkeeper, to: keeper)
                self.applySnapshot(by: .defender, to: defender)
                self.applySnapshot(by: .midfielder, to: midfielder)
                self.applySnapshot(by: .striker, to: striker)
                self.stopLoadingView()
            }
        }
    }
    
    private func startLoadingView() {
        self.loadingView.startAnimating()
    }
    
    private func stopLoadingView() {
        self.loadingView.stopAnimating()
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
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createDatasource() {
        guard let collectionView = self.collectionView else { return }
        
        let cellRegistration = UICollectionView.CellRegistration<PlayerImageCell, UIImage> { cell, indexPath, itemIdentifier in
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            
            cell.updateImage(itemIdentifier)
        }
        
        datasource = UICollectionViewDiffableDataSource<PlayerSection, UIImage>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    private func applySnapshot(by section: PlayerSection, to images: [UIImage]) {
        snapshot.appendSections([section])
        snapshot.appendItems(images)
        
        self.datasource?.apply(snapshot)
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
        
        configureLoadingView()
        startLoadingView()
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
    
    private func configureLoadingView() {
        self.loadingView.center = self.view.center
        self.loadingView.color = .red
        
        self.view.addSubview(self.loadingView)
    }
}
