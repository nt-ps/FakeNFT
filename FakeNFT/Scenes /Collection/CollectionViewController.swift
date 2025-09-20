import UIKit
import ProgressHUD

typealias CollectionDataSourceSnapshot = NSDiffableDataSourceSnapshot<CollectionCollectionSection, NftCellModel>

// MARK: - Protocol

protocol CollectionViewControllerProtocol: AnyObject, LoadingView, ErrorView {
    var presenter: CollectionPresenterProtocol { get }
    
    func updateCollectionViewAnimated(from newNfts: [NftCellModel])
    func setAuthor(name: String, webcite: String?)
    func setLike(_ value: Bool, for cellIndex: Int)
    func setStateInCart(_ value: Bool, for cellIndex: Int)
}

// MARK: - Implementation

final class CollectionViewController: UICollectionViewController, CollectionViewControllerProtocol {
    
    // TODO: Добавить прогресс (показывается при нажатии лайка и кнопки корзины).
    
    // MARK: - Views
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .AppColors.black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    } ()
    
    // MARK: - Internal Properties
    
    let presenter: CollectionPresenterProtocol
    
    // MARK: - Private Properties

    private lazy var dataSource: CollectionDataSource = .init(
        collectionView,
        presenter: presenter,
        headerDelegate: self,
        cellDelegate: self
    )
    private var nfts: [NftCellModel] = []
    
    // MARK: - UI Properties
    
    private static var cellPerGroup: CGFloat = 3
    private static var cellSpacing: CGFloat = 8
    private static var groupXSpacing: CGFloat = 16
    private static var sectionYSpacing: CGFloat = 20
    
    // MARK: - Initializers

    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        let layout = CollectionViewController.createLayout(
            withHeader: presenter.headerModel != nil
        )
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CollectionViewController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view.safeAreaLayoutGuide)
        
        setNavigationBar()
        configureCollectionView()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Overridden Methods

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentYOffset = scrollView.contentOffset.y
        if contentYOffset <= 0 {
            guard
                let header = collectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionHeader,
                    at: IndexPath(row: 0, section: 0)
                ) as? CollectionCollectionHeader
            else { return }

            header.stretch(to: -contentYOffset)
        }
    }
    
    // MARK: - Collection View Controller Protocol
    
    func updateCollectionViewAnimated(from newNfts: [NftCellModel]) {
        nfts = newNfts
        
        var snapshot = CollectionDataSourceSnapshot()
        snapshot.appendSections([CollectionCollectionSection.main])
        snapshot.appendItems(newNfts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setAuthor(name: String, webcite: String?) {
        guard
            let header = collectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(row: 0, section: 0)
            ) as? CollectionCollectionHeader
        else { return }
        
        header.authorName = name
        header.authorWebsite = webcite
    }
    
    func setLike(_ value: Bool, for cellIndex: Int) {
        guard
            let cell = collectionView.cellForItem(
                at: IndexPath(row: cellIndex, section: 0)
            ) as? CollectionCollectionCell
        else { return }
        
        cell.isLiked = value
    }
    
    func setStateInCart(_ value: Bool, for cellIndex: Int) {
        guard
            let cell = collectionView.cellForItem(
                at: IndexPath(row: cellIndex, section: 0)
            ) as? CollectionCollectionCell
        else { return }
        
        cell.inCart = value
    }
    
    // MARK: - Collection View Delegate Methods
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let nft = nfts[indexPath.row]
        let nftDetail = NftDetailInput(id: nft.id)
        let nftViewController = presenter.nftDetailAssembler.build(with: nftDetail)
        present(nftViewController, animated: true)
    }
    
    // MARK: - UI Updates
    
    func showLoading() {
        activityIndicator.startAnimating()
        collectionView.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        collectionView.isUserInteractionEnabled = true
    }
    
    private func setNavigationBar() {
        if let title = presenter.title {
            navigationItem.title = title
        } else {
            let scrollAppearance = UINavigationBarAppearance()
            scrollAppearance.configureWithTransparentBackground()

            navigationItem.scrollEdgeAppearance = scrollAppearance
            
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .AppColors.white
        
        collectionView.register(CollectionCollectionCell.self)
        collectionView.register(
            CollectionCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    // MARK: - Private Methods
    
    private static func createLayout(withHeader: Bool) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / cellPerGroup),
            heightDimension: .estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(cellSpacing)
        group.contentInsets = .init(
            top: 0,
            leading: groupXSpacing,
            bottom: 0,
            trailing: groupXSpacing
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = cellSpacing
        section.contentInsets = .init(
            top: sectionYSpacing,
            leading: 0,
            bottom: sectionYSpacing,
            trailing: 0
        )
        
        if withHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension CollectionViewController: CollectionCollectionHeaderDelegate {
    func show(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func show(error model: ErrorModel) {
        showError(model)
    }
}

extension CollectionViewController: CollectionCollectionCellDelegate {
    func switchLike(for cell: CollectionCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.switchLike(for: indexPath.row)
    }
    
    func switchStateInCart(for cell: CollectionCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.switchStateInCart(for: indexPath.row)
    }
}
