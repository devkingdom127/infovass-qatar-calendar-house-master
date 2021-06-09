//
//  OffaratRouter.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/30/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit

class QCHRouter: NSObject, Router {
    
    private var completions: [UIViewController : () -> Void]
    
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public unowned let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
    }
    
    public func toShowable() -> UIViewController {
        return navigationController
    }
    
    func present(_ module: Showable, animated: Bool) {
        let module = module.toShowable()
        module.modalPresentationStyle = .overFullScreen
        module.modalTransitionStyle = .crossDissolve
        navigationController.present(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Showable, animated: Bool, completion: (() -> Void)?) {
        //avoid pushing navigation controllers
        let controller = module.toShowable()
        
        guard controller is UINavigationController == false else {
            present(module, animated: animated)
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func fade(to viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        navigationController.view.layer.add(transition, forKey: nil)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    fileprivate func runCompletion(for controller: UIViewController) {
        
        guard let completion = completions[controller] else {
            return
        }
        
        completion()
        completions.removeValue(forKey: controller)
        
    }
}

//extension QCHRouter: UINavigationControllerDelegate {
//    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        
//        //Make sure the view controller is popping, not pushing, and check for existence
//        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppedViewController) else {
//            return
//        }
//        
//        //as long as the closure is properly setup, it can now be used to clean up any resources
//        runCompletion(for: poppedViewController)
//    }
//    
//    
//}
