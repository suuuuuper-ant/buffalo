//
//  NewsContainerViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/04/28.
//

import UIKit

class NewsContainerViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var currentIndex: Int = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = currentIndex
            segmentedControl.changeUnderlinePosition()

        }
    }

    var pageViewController: FeedPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.addUnderlineForSelectedSegment()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "FeedPageViewController" {
            guard let feedVC = segue.destination as? FeedPageViewController else { return }
            pageViewController = feedVC

            pageViewController?.completeHandler = { (result) in
                self.currentIndex = result
            }
        }
    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {

        segmentedControl.changeUnderlinePosition()

        //페이징
        switch sender.selectedSegmentIndex {
        case 0:
            pageViewController?.setVCFromIndex(index: 0)
        case 1:
            pageViewController?.setVCFromIndex(index: 1)
        default:
            pageViewController?.setVCFromIndex(index: 0)
        }

    }

}
