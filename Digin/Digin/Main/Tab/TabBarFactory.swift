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
        home.tabBarItem.tag = 0
        home.tabBarItem.image = UIImage(named: "icTabHome")?.withRenderingMode(.alwaysOriginal)
        home.tabBarItem.selectedImage = UIImage(named: "icTabHomeBlue")?.withRenderingMode(.alwaysOriginal)
        home.tabBarItem.title = "홈"
        return home
    }
}

class SearchTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let search =  UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: "SearchNaviViewController")
        search.tabBarItem.tag = 1
        search.tabBarItem.image = UIImage(named: "icTabSearch")?.withRenderingMode(.alwaysOriginal)
        search.tabBarItem.selectedImage = UIImage(named: "icTabSearchBlue")?.withRenderingMode(.alwaysOriginal)
        search.tabBarItem.title = "검색"
        return search
    }
}

class NewsFeedTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let newsFeed = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsContainerViewController.reuseIdentifier)
        newsFeed.tabBarItem.tag = 2
        newsFeed.tabBarItem.image = UIImage(named: "icTabFeed")?.withRenderingMode(.alwaysOriginal)
        newsFeed.tabBarItem.selectedImage = UIImage(named: "icTabFeedBlue")?.withRenderingMode(.alwaysOriginal)
        newsFeed.tabBarItem.title = "뉴스피드"
        return newsFeed
    }
}

class MyPageTabBarCotentFactory: TabBarCotentFactory {
    func getTabBarContent() -> UIViewController {
        let myPage =  UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: "MyPageNaviViewController")
        myPage.tabBarItem.tag = 3
        myPage.tabBarItem.image = UIImage(named: "icTabMy")?.withRenderingMode(.alwaysOriginal)
        myPage.tabBarItem.selectedImage = UIImage(named: "icTabMyBlue")?.withRenderingMode(.alwaysOriginal)
        myPage.tabBarItem.title = "마이디긴"
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
