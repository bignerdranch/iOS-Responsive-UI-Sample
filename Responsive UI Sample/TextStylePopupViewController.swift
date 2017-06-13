//
//  TextStylePopupViewController.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

private struct ActionSpec {
    let selector: Selector
    let title: String
    let image: UIImage
}

private extension UISegmentedControl {

    func insertSegment(_ action: ActionSpec, at index: Int, animated: Bool = false) {
        action.image.accessibilityIdentifier = String(describing: action.selector)
        action.image.accessibilityLabel = action.title
        insertSegment(with: action.image, at: index, animated: animated)
    }

}

final class TextStylePopupViewController: UIViewController, WantsSystemSpacingInStackViews {

    weak var textView: UITextView?

    @IBOutlet private var textButtons: UISegmentedControl!
    @IBOutlet private var indentButtons: UISegmentedControl!
    @IBOutlet private(set) var prefersSystemSpacing: [UIStackView]!

    private let textActions = [
        ActionSpec(selector: #selector(UIResponder.toggleBoldface), title: NSLocalizedString("text-style:bold", comment: "The user wants to toggle boldface on text. (Button)"), image: #imageLiteral(resourceName: "format_style_bold")),
        ActionSpec(selector: #selector(UIResponder.toggleItalics), title: NSLocalizedString("text-style:italic", comment: "The user wants to toggle italics on text. (Button)"), image: #imageLiteral(resourceName: "format_style_italic")),
        ActionSpec(selector: #selector(UIResponder.toggleUnderline), title: NSLocalizedString("text-style:underline", comment: "The user wants to toggle an underline on text. (Button)"), image: #imageLiteral(resourceName: "format_style_underline")),
        ActionSpec(selector: #selector(ResponderExtendedStylingActions.toggleStrikethrough), title: NSLocalizedString("text-style:strike", comment: "The user wants to toggle strikethrough on text. (Button)"), image: #imageLiteral(resourceName: "format_style_strikethrough"))
    ]

    private let indentActions = [
        ActionSpec(selector: #selector(ResponderExtendedStylingActions.decreaseIndent), title: NSLocalizedString("text-style:indent-decrease", comment: "The user wants to decrease indent on a list. (Button)"), image: #imageLiteral(resourceName: "format_style_indent_left")),
        ActionSpec(selector: #selector(ResponderExtendedStylingActions.increaseIndent), title: NSLocalizedString("text-style:indent-increase", comment: "The user wants to increase indent on a list. (Button)"), image: #imageLiteral(resourceName: "format_style_indent_right"))
    ]

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        textButtons.removeAllSegments()
        for spec in textActions.reversed() {
            textButtons.insertSegment(spec, at: 0)
        }

        indentButtons.removeAllSegments()
        for spec in indentActions.reversed() {
            indentButtons.insertSegment(spec, at: 0)
        }

        configureSystemSpacingInStackViews()
    }

    // MARK: - Actions

    private func handle(_ action: ActionSpec) {
        guard let textView = textView, let target = textView.target(forAction: action.selector, withSender: self) else { return }
        _ = (target as AnyObject).perform(action.selector, with: self)
    }

    @IBAction private func onTextAction(_ sender: UISegmentedControl) {
        handle(textActions[sender.selectedSegmentIndex])
    }

    @IBAction private func onIndentAction(_ sender: UISegmentedControl) {
        handle(indentActions[sender.selectedSegmentIndex])
    }

}
