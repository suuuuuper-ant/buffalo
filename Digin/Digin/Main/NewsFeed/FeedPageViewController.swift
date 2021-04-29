//
//  FeedPageViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/04/28.
//

import UIKit

class FeedPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let viewsList: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "NewsFeed", bundle: nil)

        guard let vc1 = storyBoard.instantiateViewController(withIdentifier: NewsFeedViewController.reuseIdentifier) as? NewsFeedViewController else { return [UIViewController]() }
        vc1.type = 0

        guard let vc2 = storyBoard.instantiateViewController(withIdentifier: NewsFeedViewController.reuseIdentifier) as? NewsFeedViewController else { return [UIViewController]() }
        vc2.type = 1

        return [vc1, vc2]

    }()

    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }

    var completeHandler: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self

        if let firstvc = viewsList.first {
            self.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }

        return viewsList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil }

        return viewsList[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            completeHandler?(currentIndex)
        }
    }

    func setVCFromIndex(index: Int) {
        if index < 0 && index >= viewsList.count { return }
        if index == 0 {
            self.setViewControllers([self.viewsList[index]], direction: .reverse, animated: true, completion: nil)
        }

        if index == 1 {
            self.setViewControllers([self.viewsList[index]], direction: .forward, animated: true, completion: nil)
        }

        completeHandler?(currentIndex)
    }
}
