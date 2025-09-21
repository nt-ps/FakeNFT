//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

protocol MyNFTViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showNFTs(_ nfts: [Nft])
    func showError(_ message: String)
    func showEmptyState()
    func updateSortButtonState(isEnabled: Bool)
}

final class MyNFTViewController: UIViewController, ViewControllerDelegate {

    // MARK: Properties
    private let myNFTView = MyNFTView()
    private var presenter: MyNFTPresenterProtocol?

    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    init(presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setPresenter(_ presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
    }

    override func loadView() {
        view = myNFTView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        myNFTView.tableView.dataSource = self
        presenter?.viewDidLoad()
    }
    
    // MARK: Setup
    private func setupView() {
        let backButton = NavigationBackButton()
        backButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let sortButton = NavigationSortButton()
        sortButton.addTarget(self, action: #selector(sortTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)

        navigationItem.title = L10n.Profile.MyNFT.title
    }


    // MARK: Actions
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sortTapped() {
        presenter?.didTapSort()
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presenter = presenter as? MyNFTPresenter {
            return presenter.getNFTCount()
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        
        if let presenter = presenter as? MyNFTPresenter,
           let nft = presenter.getNFT(at: indexPath.row) {
            cell.configCell(model: nft)
        }
        return cell
    }
}

// MARK: - MyNFTViewProtocol
extension MyNFTViewController: MyNFTViewProtocol {
    
    func showLoading() {
        myNFTView.changeState(.loading)
    }
    
    func hideLoading() {
        myNFTView.tableView.reloadData()
    }
    
    func showNFTs(_ nfts: [Nft]) {
        myNFTView.changeState(.standart)
        myNFTView.tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alertModel = AlertModel.error(message: message)
        AlertPresenter.present(in: self, model: alertModel)
    }
    
    func showEmptyState() {
        myNFTView.changeState(.empty)
        myNFTView.tableView.reloadData()
    }
    
    func updateSortButtonState(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}
