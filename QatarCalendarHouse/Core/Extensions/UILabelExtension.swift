//
//  UILabelExtension.swift
//  BaitAladl
//
//  Created by Amr Salman on 17/5/19.
//  Copyright © 2019 infovass. All rights reserved.
//

import UIKit

extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font?.pointSize ?? 13.0) }
    }
    
    /// Will auto resize the contained text to a font size which fits the frames bounds.
    /// Uses the pre-set font to dynamically determine the proper sizing
    func fitTextToBounds() {
        guard let text = text, let currentFont = font else { return }
        
        let bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds, fontDescriptor: currentFont.fontDescriptor, additionalAttributes: basicStringAttributes)
        font = bestFittingFont
    }
    
    private var basicStringAttributes: [NSAttributedString.Key: Any] {
        var attribs = [NSAttributedString.Key: Any]()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode
        attribs[.paragraphStyle] = paragraphStyle
        
        return attribs
    }
    
    
}

extension UILabel {

    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        self.layoutIfNeeded()
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font]

        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }

    func isTruncated() -> Bool {

        if (self.countLabelLines() > self.numberOfLines) {
            return true
        }
        return false
    }
}
