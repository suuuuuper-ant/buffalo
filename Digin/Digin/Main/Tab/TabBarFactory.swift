//
//  TabBarFactory.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

enum TabBarType: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case newsFeed = "newsFeed"
    case myPage = "myPage"
}

protocol TabBarCotentFactory {

    func getTabBarContent() -> UIViewController
}

class HomeTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let home =   UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        return home
    }
}

class SearchTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let search =  UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: "SearchNaviViewController")
        search.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return search
    }
}

class NewsFeedTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let newsFeed =  UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsContainerViewController.reuseIdentifier)
        newsFeed.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        return newsFeed
    }
}

class MyPageTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let myPage =  MypageViewController()
        myPage.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        return myPage
    }
}

class MainTabarFactorySet {
    var types: [TabBarType]

    init(_ types: [TabBarType]) {
        self.types = types
    }

    func generateForTabBarType() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        for type in types {
            switch type {
            case .home:
                viewControllers.append(HomeTabBarCotentFactory().getTabBarContent())
            case .search:
                viewControllers.append(SearchTabBarCotentFactory().getTabBarContent())
            case .newsFeed:
                viewControllers.append(NewsFeedTabBarCotentFactory().getTabBarContent())
            case .myPage:
                viewControllers.append(MyPageTabBarCotentFactory().getTabBarContent())
            }
        }
        return viewControllers
    }
}
