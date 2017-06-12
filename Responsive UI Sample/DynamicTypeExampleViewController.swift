//
//  DynamicTypeExampleViewController.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

class DynamicTypeExampleViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleHairlineHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        titleHairlineHeight.constant = traitCollection.hairline
    }

}
