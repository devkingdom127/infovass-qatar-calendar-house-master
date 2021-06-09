//
//  Sharable.swift
//
//  Created by Amr Salman on 7/4/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import UIKit

protocol Sharable {
    func share(_ str: String, source: UIView?, completionHandler: ((_ completed: Bool) -> Void)?)
}

extension UIViewController: Sharable {
    func share(_ str: String, source: UIView? = nil, completionHandler: ((_ completed: Bool) -> Void)? = nil) {
        let activityController = UIActivityViewController.init(activityItems: [str], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = source ?? self.view
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            completionHandler?(completed)
        }

        self.present(activityController, animated: true, completion: nil)
    }
    
    func share(_ data: Data, source: UIView? = nil, completionHandler: ((_ completed: Bool) -> Void)? = nil) {
        let activityController = UIActivityViewController.init(activityItems: [data], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = source ?? self.view
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            completionHandler?(completed)
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
}
