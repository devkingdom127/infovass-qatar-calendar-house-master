//
//  TextDetailsVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 5/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class TextDetailsVC: UIViewController, Storyboarded {

    
    //MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Properties
    
    var titleStr: String?
    var details: String?
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - Actions
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers

    private func setup() {
        let attributedString = NSMutableAttributedString(string: (titleStr ?? "") + "\n" + (details ?? ""))
        
        let centerStyle = NSMutableParagraphStyle()
        centerStyle.alignment = .center
        
        attributedString.addAttributes([NSAttributedString.Key.font: R.font.cairoSemiBold(size: 17)!, NSAttributedString.Key.paragraphStyle: centerStyle, NSAttributedString.Key.foregroundColor: R.color.black()!], range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttributes([NSAttributedString.Key.font: R.font.cairoBold(size: 18)!, NSAttributedString.Key.foregroundColor: R.color.primary()!], range: attributedString.mutableString.range(of: titleStr ?? ""))

        textView.attributedText = attributedString
    }
    
    private func adjustUITextViewHeight(arg : UITextView) {
        if arg.frame.size.height >= arg.contentSize.height {
            arg.translatesAutoresizingMaskIntoConstraints = true
            arg.sizeToFit()
            arg.isScrollEnabled = false
            arg.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            arg.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        }
    }

    
}
