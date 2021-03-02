//
//  BaseRouter.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 28.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import Foundation
import UIKit

class BaseRouter{
    
    var viewController: UIViewController!
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
    final func push(vc: UIViewController, animated : Bool = true) {
        viewController.navigationController?.pushViewController(vc, animated: animated)
    }
    
    final func dismiss(animated : Bool = true, completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: animated, completion: completion)
    }
}
