//
//  StackViewCompatibility.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/12/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

@objc protocol WantsSystemSpacingInStackViews: class {

    var prefersSystemSpacing: [UIStackView]! { get }

}

extension WantsSystemSpacingInStackViews {

    func configureSystemSpacingInStackViews() {
        #if swift(>=3.2)
        if #available(iOS 11.0, *) {
            for stackView in prefersSystemSpacing {
                stackView.spacing = UIStackView.spacingUseSystem
            }
        }
        #endif
    }
}
