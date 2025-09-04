import UIKit

final class CatalogueNavigationController: UINavigationController {

    // MARK: - Internal Properties
    
    let servicesAssembly: ServicesAssembly

    // MARK: - Initializers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CatalogueNavigationController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .AppColors.white
        navigationBar.tintColor = .AppColors.black
        
        let cataloguePresenter = CataloguePresenter(
            servicesAssembler: servicesAssembly
        )
        let catalogueViewController = CatalogueViewController(presenter: cataloguePresenter)
        cataloguePresenter.view = catalogueViewController
        
        viewControllers = [ catalogueViewController ]
    }
}
