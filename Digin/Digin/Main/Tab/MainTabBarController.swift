//
//  MainTabBarController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        builderTab()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func builderTab() {

     let viewControllers =    MainTabarFactorySet(TabBarType.allCases).generateForTabBarType()

        tabBar.tintColor = AppColor.mainColor.color
        tabBar.barTintColor = UIColor.appColor(.bgLightGrey)
        self.viewControllers = viewControllers

    }
}
