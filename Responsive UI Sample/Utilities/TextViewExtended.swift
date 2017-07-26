//
//  TextViewExtended.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/12/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

@objc protocol ResponderExtendedStylingActions: NSObjectProtocol {
    func toggleStrikethrough(_ sender: Any?)
    func increaseIndent(_ sender: Any?)
    func decreaseIndent(_ sender: Any?)
}

@objc protocol ResponderExtendedStyling: ResponderExtendedStylingActions {
    var refusesStandardEditingCommands: Bool { get set }
}

final class ExtendedStylingTextView: UITextView, ResponderExtendedStyling {

    /// Prevents the callout menu from showing
    var refusesStandardEditingCommands = false {
        didSet {
            if isFirstResponder, isEditable, refusesStandardEditingCommands {
                UIMenuController.shared.setMenuVisible(false, animated: true)
            }
        }
    }

    // MARK: - UIResponder

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case _ where refusesStandardEditingCommands && sender is UIMenuController:
            return false
        case #selector(ResponderExtendedStylingActions.toggleStrikethrough),
             #selector(ResponderExtendedStylingActions.increaseIndent), #selector(ResponderExtendedStylingActions.decreaseIndent):
            return isFirstResponder && isEditable ? allowsEditingTextAttributes : false
        case #selector(UIResponder.toggleBoldface), #selector(UIResponder.toggleItalics), #selector(UIResponder.toggleUnderline):
            return sender is UIMenuController ? false : super.canPerformAction(action, withSender: sender)
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }

    // MARK: - Actions

    private func toggleStyle(ifPresent isPresent: ([String: Any]) -> Bool = { _ in false }, byAdding add: (NSMutableAttributedString, inout NSRange) -> Void, removing remove: (NSMutableAttributedString, inout NSRange) -> Void, orResetting resetTypingAttributes: (inout [String: Any]) -> Void) {
        var range = selectedRange

        // Check and see if we find any attributes corresponding to this style.
        var foundMatch = false
        textStorage.enumerateAttributes(in: range) { (attributes, range, stop) in
            guard isPresent(attributes) else { return }
            foundMatch = true
            stop.pointee = true
        }

        if textStorage.length == 0 || !foundMatch {
            // If we didn't find a match, turn on the style.
            add(textStorage, &range)
        } else if foundMatch {
            // If we did find a match, remove the style.
            remove(textStorage, &range)
        }

        // Otherwise, remove it from the characters the user next types in.
        if range.length == 0 {
            resetTypingAttributes(&typingAttributes)
        }

        // The SDK only sends textViewDidChange(_:) when it managed the change.
        delegate?.textViewDidChange?(self)
    }

    @objc func toggleStrikethrough(_ sender: Any?) {
        toggleStyle(ifPresent: { (attributes) -> Bool in
            attributes[NSStrikethroughStyleAttributeName] != nil
        }, byAdding: { (text, range) in
            text.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        }, removing: { (text, range) in
            text.removeAttribute(NSStrikethroughStyleAttributeName, range: range)
        }, orResetting: { (attributes) in
            attributes.removeValue(forKey: NSStrikethroughStyleAttributeName)
        })
    }

    // Given the current paragraph for a range, duplicate its paragraph style and offset the indentation.
    private func adjustIndent(of text: NSMutableAttributedString, in range: inout NSRange, by indentationDelta: CGFloat) {
        range = (text.string as NSString).paragraphRange(for: range)
        text.enumerateAttribute(NSParagraphStyleAttributeName, in: range) { (paragraphStyle, range, _) in
            let newStyle = NSMutableParagraphStyle()
            (paragraphStyle as? NSParagraphStyle).map(newStyle.setParagraphStyle)

            newStyle.headIndent = max(0, newStyle.headIndent + indentationDelta)
            newStyle.firstLineHeadIndent = max(0, newStyle.firstLineHeadIndent + indentationDelta)

            text.addAttribute(NSParagraphStyleAttributeName, value: newStyle, range: range)
        }
    }

    // Given an attributes dictionary, remove any indentation on the paragraph style.
    private func resetIndent(ofAttributes attributes: inout [String: Any]) {
        let newStyle = NSMutableParagraphStyle()
        if let currentStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
            newStyle.setParagraphStyle(currentStyle)
        }

        newStyle.headIndent = 0
        newStyle.firstLineHeadIndent = 0

        attributes[NSParagraphStyleAttributeName] = newStyle
    }

    private func toggleIndent(by indentationDelta: CGFloat) {
        toggleStyle(byAdding: { (text, range) in
            adjustIndent(of: text, in: &range, by: indentationDelta)
        }, removing: { (text, range) in
            adjustIndent(of: text, in: &range, by: -indentationDelta)
        }, orResetting: resetIndent)
    }

    @objc func increaseIndent(_ sender: Any?) {
        toggleIndent(by: 36)
    }

    @objc func decreaseIndent(_ sender: Any?) {
        toggleIndent(by: -36)
    }

}
