//
//  MainTabBarController.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/23/24.
//

import Then
import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let appearance = UITabBarAppearance().then {
        $0.configureWithOpaqueBackground()
        $0.backgroundColor = .lightBackground
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewController()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        tabBar.tintColor = .white
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func configureViewController() {
        let discover = templateNavigationController(rootViewController: DiscoverViewController(), title: "Discover", image: "film", selectedImage: "film.fill")
        let chart = templateNavigationController(rootViewController: ChartViewController(), title: "Charts", image: "list.number", selectedImage: "list.number")
        let credit = templateNavigationController(rootViewController: UIViewController(), title: "Credit", image: "ellipsis", selectedImage: "Credits")
        
        delegate = self
        viewControllers = [discover, chart, credit]
    }
    
    private func templateNavigationController(rootViewController: UIViewController, title: String, image: String, selectedImage: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), selectedImage: UIImage(systemName: selectedImage))
        
        return navigationController
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("DEBUG: Select \(viewController.title ?? "")")
        
        return true
    }
}

// MARK: - Preview

#Preview {
    MainTabBarController()
}
