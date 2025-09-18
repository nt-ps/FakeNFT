import UIKit

public final class NftDetailAssembly {

    private let nftService: NftService

    init(nftService: NftService) {
        self.nftService = nftService
    }

    public func build(with input: NftDetailInput) -> UIViewController {
        let presenter = NftDetailPresenterImpl(
            input: input,
            service: nftService
        )
        let viewController = NftDetailViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
