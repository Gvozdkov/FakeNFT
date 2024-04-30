import UIKit

protocol FavoriteNFTViewControllerProtocol {
    
    func refreshNfts(nfts: [FavoriteNFT])
}

class FavoriteNFTViewController: UIViewController {
    
    var presenter: FavoriteNFTPresenterProtocol?
    
    private var visibleNfts: [FavoriteNFT] = []
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.action = #selector(close)
        button.target = self
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let colView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colView.backgroundColor = .ypWhite
        colView.dataSource = self
        colView.delegate = self
        colView.register(
            ProfileFavoriteNFTCollectionCell.self,
            forCellWithReuseIdentifier: ProfileFavoriteNFTCollectionCell.reuseIdentifier
        )
        colView.translatesAutoresizingMaskIntoConstraints = false
        return colView
    }()
    
    private lazy var emptyNFTsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.text = "У Вас ещё нет избранных NFT"
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavBar()
        addElements()
        setupConstraints()
        
        presenter?.loadNfts()
    }
        
    
    @objc private func close() {
        print("closed")
        navigationController?.popViewController(animated: true)
    }
    
    private func addElements() {
        view.addSubview(collectionView)
        view.addSubview(emptyNFTsLabel)
    }
    
    private func setupNavBar(){
        navigationItem.title = "Избранные NFT"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyNFTsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNFTsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension FavoriteNFTViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleNfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileFavoriteNFTCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileFavoriteNFTCollectionCell ?? ProfileFavoriteNFTCollectionCell()

        cell.configCell(visibleNfts[indexPath.row])

        return cell
    }
}

//MARK: - FavoriteNFTControllerProtocol
extension FavoriteNFTViewController: FavoriteNFTViewControllerProtocol {
    
    func refreshNfts(nfts: [FavoriteNFT]) {
        visibleNfts = nfts
        
        collectionView.reloadData()
        
        if visibleNfts.isEmpty {
            emptyNFTsLabel.isHidden = false
            collectionView.isHidden = true
            
            navigationItem.title = ""
            
        } else {
            emptyNFTsLabel.isHidden = true
            collectionView.isHidden = false
            
            navigationItem.title = "Избранные NFT"
        }
    }
}

extension FavoriteNFTViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 48) / 2
        return CGSize(width: cellWidth, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        return inset
    }
}

