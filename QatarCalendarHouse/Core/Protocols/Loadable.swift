//
//  Loadable.swift
//
//  Created by Amr Salman on 7/4/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import UIKit
import Loaf

protocol Loadable {
    func startLoading(shouldFreeze: Bool)
    func stopLoading(withErrorMessage message: String?)
    func showCompleted(completeHandler: @escaping () -> Void)
}

extension UIViewController: Loadable {
    func startLoading(shouldFreeze: Bool = false) {
        ProgressHUD.shared.show()
        if shouldFreeze {
//            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func stopLoading(withErrorMessage message: String? = nil) {
        ProgressHUD.shared.hide()
        UIApplication.shared.endIgnoringInteractionEvents()
        if let message = message {
            Loaf(message, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    func showCompleted(completeHandler: @escaping () -> Void) {
        Loaf("تم بنجاح", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.short) { _ in
            completeHandler()
        }
    }
}
