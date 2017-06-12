//
//  ReflowExampleViewController.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

private struct ButtonSpec {
    let identifier: String
    let title: String
    let image: UIImage
}

final class ReflowExampleViewController: UIViewController {

    private enum Constants {
        static let buttonTitlePadding: CGFloat = 6
    }

    @IBOutlet private var primaryContainer: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleHairlineHeight: NSLayoutConstraint!
    @IBOutlet private var buttonContainer: UIStackView!

    private enum ButtonIdentifier: String {
        case message, phone, web, favorite, share
    }

    private let buttons = [
        ButtonSpec(identifier: ButtonIdentifier.phone.rawValue, title: NSLocalizedString("reflow-button:phone", comment: "The user wants to call us. (Button)"), image: #imageLiteral(resourceName: "reflow_button_any")),
        ButtonSpec(identifier: ButtonIdentifier.web.rawValue, title: NSLocalizedString("reflow-button:web", comment: "The user wants to visit our web site. (Button)"), image: #imageLiteral(resourceName: "reflow_button_any")),
        ButtonSpec(identifier: ButtonIdentifier.favorite.rawValue, title: NSLocalizedString("reflow-button:favorite", comment: "The user wants to mark us as a favorite. (Button)"), image: #imageLiteral(resourceName: "reflow_button_any")),
        ButtonSpec(identifier: ButtonIdentifier.share.rawValue, title: NSLocalizedString("reflow-button:share", comment: "The user wants to share our contact card. (Button)"), image: #imageLiteral(resourceName: "reflow_button_any"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false

        for spec in buttons {
            let button = makeButton(for: spec)
            buttonContainer.addArrangedSubview(button)
        }

        configureButtons(for: .horizontal)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        titleHairlineHeight.constant = traitCollection.hairline
    }

    // MARK: - Layout

    //// STOPPING POINT:
    //// MAKE THIS WORK

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Make sure the container has completed layout.
        primaryContainer.layoutIfNeeded()
        buttonContainer.layoutIfNeeded()

        // Is one of the buttons clipped?
        guard buttonContainer.arrangedSubviews.contains(where: { $0.frame.width < $0.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width.rounded() }) else { return }

        print("Detected truncation!")
    }

    // MARK: - Helpers

    private func makeButton(for spec: ButtonSpec) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.setTitle(spec.title, for: .normal)
        button.setImage(spec.image, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleEdgeInsets.left = Constants.buttonTitlePadding
        if #available(iOS 11.0, *) {
            button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        }
        button.addTarget(self, action: #selector(didSelectButton), for: .primaryActionTriggered)
        return button
    }

    private func configureButtons(for axis: UILayoutConstraintAxis) {
        buttonContainer.axis = axis
        switch axis {
        case .horizontal:
            buttonContainer.alignment = .firstBaseline
            buttonContainer.distribution = .equalSpacing
        case .vertical:
            buttonContainer.alignment = .fill
            buttonContainer.distribution = .fill
        }
    }

    // MARK: - Actions

    @objc private func didSelectButton(_ sender: UIButton) {
        guard let index = buttonContainer.arrangedSubviews.index(of: sender) else { return }

        let button = buttons[index]
        guard let identifier = ButtonIdentifier(rawValue: button.identifier) else { return }

        let alert = UIAlertController(title: NSLocalizedString("reflow-alert:title", comment: "Informational title: one of the demo reflow button was picked. (Title)"), message: String(describing: identifier), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("generic:alert-ok", comment: "The user wants to dismiss an informational alert. (Button)"), style: .default))
        present(alert, animated: true)
    }

}
