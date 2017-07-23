//
//  MixerViewController.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/8/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

class MixerViewController: UIViewController {

    @IBOutlet private var childrenContainer: UIView!
    @IBOutlet private var childrenTrailingMargin: NSLayoutConstraint!
    @IBOutlet private var textSizeSlider: UISlider!
    @IBOutlet private var marginSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Substitute an effect for the typical navigation bar.
        let effect = BackgroundBlendingView(effect: .statusBarLight)
        effect.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effect)
        NSLayoutConstraint.activate([
            effect.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: effect.trailingAnchor),
            effect.topAnchor.constraint(equalTo: view.topAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: effect.bottomAnchor)
        ])

        resetMarginAndSlider()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        resetMarginAndSlider(with: size)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        resetTextSizeSlider()
    }

    // MARK: - Text Size

    private let textSizes: [UIContentSizeCategory] = [
        .extraSmall, .small, .medium, .large,
        .extraLarge, .extraExtraLarge, .extraExtraExtraLarge,
        .accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge
    ]

    private func value(for category: UIContentSizeCategory) -> Float {
        return textSizes.index(of: category).map(Float.init) ?? value(for: .large)
    }

    private func resetTextSizeSlider() {
        textSizeSlider.maximumValue = Float(textSizes.count)
        textSizeSlider.value = value(for: traitCollection.preferredContentSizeCategory)
    }

    // MARK: - Margin

    private func resetMarginAndSlider(with size: CGSize? = nil) {
        childrenTrailingMargin.constant = 0
        marginSlider.maximumValue = Float(size?.width ?? view.bounds.width)
        marginSlider.value = 0
    }

    @IBAction private func updateMargin(from slider: UISlider) {
        childrenTrailingMargin.constant = CGFloat(slider.value)
    }

}
