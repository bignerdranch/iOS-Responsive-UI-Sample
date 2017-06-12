//
//  DynamicTypeExampleViewController.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

class DynamicTypeExampleViewController: UIViewController, WantsSystemSpacingInStackViews {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleHairlineHeight: NSLayoutConstraint!
    @IBOutlet private(set) var prefersSystemSpacing: [UIStackView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false

        configureSystemSpacingInStackViews()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        titleHairlineHeight.constant = traitCollection.hairline
    }

}
