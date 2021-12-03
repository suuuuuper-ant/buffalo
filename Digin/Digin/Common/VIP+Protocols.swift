//
//  VIP+Protocols.swift
//  Digin
//
//  Created by jinho jeong on 2021/11/22.
//

import UIKit

class ViewableRouter<Interator, PrenseterType> {

    public let presenter: PrenseterType
    public let viewControllable: ViewControllable

    init(interator: Interator, presenter: PrenseterType) {
        self.presenter = presenter
        guard let  viewControllable =  (presenter as? Presentable)?.viewController else {
            fatalError("\(presenter) should conform to \(ViewControllable.self)")
        }
        self.viewControllable = viewControllable

    }
}
//
//

protocol Interatable { }
public protocol Presentable {

     var viewController: ViewControllable { get }
}

protocol Buildable { }
class PresetableInterator<PresenterType>: Interatable {

    public let presenter: PresenterType
     init(presenter: PresenterType) {
         self.presenter = presenter
     }
}

class UpdatablePresenter: Presentable {
    var viewController: ViewControllable

    init(viewController: ViewControllable) {
        self.viewController = viewController
    }
}

public protocol ViewControllable: AnyObject {

    var uiviewController: UIViewController { get }
}

class Builder {

}
