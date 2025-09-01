import Foundation

// MARK: - Protocol

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

// MARK: - Implementation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Internal Properties
    
    var view: WebViewViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let request: URLRequest
    
    // MARK: - Initializers
    
    init(for request: URLRequest) {
        self.request = request
    }
    
    // MARK: - Internal Methods
    
    func viewDidLoad() {
        didUpdateProgressValue(0)
        view?.load(request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    // MARK: - Private Methods
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
