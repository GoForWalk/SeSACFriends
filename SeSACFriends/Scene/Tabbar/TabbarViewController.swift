//
//  TabbarViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

final class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
        self.tabBar.tintColor = Colors.green
        self.tabBar.unselectedItemTintColor = Colors.gray6
    }
    
    private func setupTabbarItem() {
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "내정보", image: Images.tabbarProfile_inAcive, selectedImage: Images.tabbarProfile)
        
        let shopVC = ShopViewController()
        shopVC.tabBarItem = UITabBarItem(title: "새싹샵", image: Images.tabbarShop_inAcive, selectedImage: Images.tabbarShop)
        
        let friendsVC = FriendsViewController()
        friendsVC.tabBarItem = UITabBarItem(title: "새싹친구", image: Images.tabbarFriends_inAcive, selectedImage: Images.tabbarFriends)
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: Images.tabbarHome_inActive, selectedImage: Images.tabbarHome)
                
        viewControllers = [
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: shopVC),
            UINavigationController(rootViewController: friendsVC),
            UINavigationController(rootViewController: homeVC)
        ]
    }
    
}

