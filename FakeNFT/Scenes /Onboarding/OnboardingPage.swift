import UIKit

final class OnboardingPage: UIPageViewController {
    static let onboardingKey = "onboardingCompleted"
    
    lazy var pages: [UIViewController] = {
        let firstPage = createPage(image: UIImage(resource: .firstPage),
                                   headerText: L10n.Onboarding.Header.firstPage,
                                   descriptionText: L10n.Onboarding.Description.firstPage,
                                   buttonText: nil)
        
        let secondPage = createPage(image: .secondPage,
                                    headerText: L10n.Onboarding.Header.secondPage,
                                    descriptionText: L10n.Onboarding.Description.secondPage,
                                    buttonText: nil)
        
        let thirdPage = createPage(image: .thirdPage,
                                   headerText: L10n.Onboarding.Header.thirdPage,
                                   descriptionText: L10n.Onboarding.Description.thirdPage,
                                   buttonText: L10n.Onboarding.exitButton)
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var stripPageControl: StripPageControl = {
        let control = StripPageControl()
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        view.addSubview(stripPageControl)
        
        NSLayoutConstraint.activate([
            stripPageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stripPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stripPageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func createPage(image: UIImage,
                    headerText: String,
                    descriptionText: String,
                    buttonText: String?) -> UIViewController {
        let vc = UIViewController()
        
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(image)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.AppColors.Universal.black.withAlphaComponent(0.8).cgColor,
            UIColor.AppColors.Universal.black.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.locations = [0.1, 0.6]
        gradientLayer.frame = vc.view.bounds
        
        let gradientView = UIView()
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(gradientView)
        
        let headerLabel = UILabel()
        headerLabel.text = headerText
        headerLabel.textColor = .AppColors.Universal.white
        headerLabel.font = .headline1
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.textAlignment = .left
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(headerLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = descriptionText
        descriptionLabel.textColor = .AppColors.Universal.white
        descriptionLabel.font = .caption1
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(descriptionLabel)
        
        if let buttonText {
            let button = UIButton(type: .system)
            button.setTitle(buttonText, for: .normal)
            button.setTitleColor(.AppColors.Universal.white, for: .normal)
            button.backgroundColor = .AppColors.Universal.black
            button.titleLabel?.font = .bodyBold
            button.layer.cornerRadius = 16
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            vc.view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
                button.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -66),
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            let button = UIButton(type: .system)
            button.setImage(.Icons.close, for: .normal)
            button.tintColor = .AppColors.Universal.white
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            vc.view.addSubview(button)

            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
                button.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 28),
                button.heightAnchor.constraint(equalToConstant: 42),
                button.widthAnchor.constraint(equalToConstant: 42)
            ])
            
        }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: vc.view.topAnchor),
            image.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 186),
            headerLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
        ])
        
        return vc
    }
    
    @objc private func buttonTapped() {
        UserDefaults.standard.set(true, forKey: OnboardingPage.onboardingKey)
        dismiss(animated: true)
    }
}

extension OnboardingPage: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let VCIndex = pages.firstIndex(of: viewController) else { return nil}
        let previousIndex = VCIndex - 1
        
        if previousIndex < 0 {
            return pages.last
        } else {
            return pages[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let VCIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = VCIndex + 1
        
        if nextIndex >= pages.count {
            return pages.first
        } else {
            return pages[nextIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            stripPageControl.currentPage = currentIndex
        }
    }
}
