//
//  TraitCollectionAdditions.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

extension UITraitCollection {

    var hairline: CGFloat {
        return 1 / max(displayScale, 1)
    }

}
