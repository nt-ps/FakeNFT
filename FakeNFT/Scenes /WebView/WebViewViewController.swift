import UIKit
import WebKit

// MARK: - Protocol

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(_ request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

// MARK: - Implementation

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    
    // MARK: - Views
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .AppColors.black
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    } ()
    
    // MARK: - Internal Properties
    
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Private Properties
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .AppColors.white

        navigationController?.setNavigationBarHidden(false, animated: true)
        
        view.addSubview(webView)
        view.addSubview(progressView)
        setConstraints()

        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self else { return }
                self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
            }
        )
    }
    
    // MARK: - Internal Methods
    
    func load(_ request: URLRequest) {
        webView.load(request)
    }
    
    // MARK: - UI Updates
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
