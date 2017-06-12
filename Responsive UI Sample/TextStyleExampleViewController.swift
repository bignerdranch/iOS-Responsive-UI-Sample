//
//  TextStyleExampleViewController.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

final class TextStyleExampleViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleHairlineHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var textStyleButton: UIButton!
    @IBOutlet fileprivate var textInput: (UITextView & ResponderExtendedStyling)!

    override func viewDidLoad() {
        super.viewDidLoad()

        textStyleButton.isEnabled = false

        textInput.font = UIFont.preferredFont(forTextStyle: .body)
        textInput.adjustsFontForContentSizeCategory = true
        textInput.allowsEditingTextAttributes = true
        textInput.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        titleHairlineHeight.constant = traitCollection.hairline
    }

    private enum Segue: String {
         case showTextStyle
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier.flatMap(Segue.init), segue.destination) {
        case (.showTextStyle?, let destination as TextStylePopupViewController):
            destination.textView = textInput
            destination.popoverPresentationController?.delegate = self
            destination.popoverPresentationController?.sourceRect = segue.destination.popoverPresentationController!.sourceView!.bounds
        default:
            assertionFailure("Invalid segue")
        }
    }

}

extension TextStyleExampleViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textStyleButton.isEnabled = true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textStyleButton.isEnabled = false
        return true
    }

}

extension TextStyleExampleViewController: UIPopoverPresentationControllerDelegate {


    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        textInput.inhibitsSelectionCommands = true
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        textInput.inhibitsSelectionCommands = false
    }

}
