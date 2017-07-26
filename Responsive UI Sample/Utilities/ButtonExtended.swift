//
//  ButtonExtended.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 7/23/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

extension UIButton: UIContentSizeCategoryAdjusting {

    public var adjustsFontForContentSizeCategory: Bool {
        get {
            return adjustsImageSizeForAccessibilityContentSizeCategory &&
                titleLabel?.adjustsFontForContentSizeCategory ?? true &&
                imageView?.adjustsImageSizeForAccessibilityContentSizeCategory ?? true
        }
        set {
            adjustsImageSizeForAccessibilityContentSizeCategory = newValue
            imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = newValue
            titleLabel?.adjustsFontForContentSizeCategory = newValue
        }
    }

}
