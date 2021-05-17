//
//  SignupFlowViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/14.
//

import UIKit

struct SignupUserInfo: Codable {

    var name: String?
    var email: String?
    var password: String?
    var favorites: [String] = []

    func getParam() throws -> [String: Any]? {

        return  try self.asDictionary()
    }

}

class SignupFlowViewController: UIPageViewController {
    var temporaryUserInfo = SignupUserInfo()
    private var currentIndex = 0
    var pages: [UIViewController] = [UIViewController]()
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pages.append(SignupNicknameViewController())
        pages.append(SignupEmailViewController())
        pages.append(SignupPasswordViewController())
        pages.append(SignupRepasswordViewController())
        pages.append(SignupInterestingViewController())

        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }

    func pushNext() {
        if currentIndex + 1 < pages.count {
            self.setViewControllers([self.pages[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            currentIndex += 1
        }
    }
}

extension SignupFlowViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return pages.last }

        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return pages.first }

        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
}

extension SignupFlowViewController: UIPageViewControllerDelegate {

    // if you do NOT want the built-in PageControl (the "dots"), comment-out these funcs

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw APIError.apiError(reason: "ParamError")
    }
    return dictionary
  }
}
