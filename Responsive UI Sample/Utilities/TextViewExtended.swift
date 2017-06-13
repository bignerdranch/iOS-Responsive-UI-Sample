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
    var inhibitsSelectionCommands: Bool { get set }
}

final class ExtendedStylingTextView: UITextView, ResponderExtendedStyling {

    /// Prevents the callout menu from showing
    var inhibitsSelectionCommands = false {
        didSet {
            if isFirstResponder, isEditable, inhibitsSelectionCommands {
                UIMenuController.shared.setMenuVisible(false, animated: true)
            }
        }
    }

    // MARK: - UIResponder

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case _ where inhibitsSelectionCommands && sender is UIMenuController:
            return false
        case #selector(ResponderExtendedStylingActions.toggleStrikethrough),
             #selector(ResponderExtendedStylingActions.increaseIndent), #selector(ResponderExtendedStylingActions.decreaseIndent):
            return isFirstResponder && isEditable ? allowsEditingTextAttributes : false
        case _ where String(describing: action).hasSuffix("showTextStyleOptions:"),
             #selector(UIResponder.toggleBoldface), #selector(UIResponder.toggleItalics), #selector(UIResponder.toggleUnderline):
            return sender is UIMenuController ? false : super.canPerformAction(action, withSender: sender)
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }

    // MARK: - Actions

    @objc func toggleStrikethrough(_ sender: Any?) {
        toggleAttributes(isPresent: { (attributes) -> Bool in
            attributes[NSStrikethroughStyleAttributeName] != nil
        }, adding: { (text, range) in
            text.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        }, removing: { (text, range) in
            text.removeAttribute(NSStrikethroughStyleAttributeName, range: range)
        }, resetTypingAttributes: { (attributes) in
            attributes.removeValue(forKey: NSStrikethroughStyleAttributeName)
        })
    }

    @objc func increaseIndent(_ sender: Any?) {
        toggleAttributes(adding: increaseIndent, removing: decreaseIndent, resetTypingAttributes: resetIndent)
    }

    @objc func decreaseIndent(_ sender: Any?) {
        toggleAttributes(adding: decreaseIndent, removing: increaseIndent, resetTypingAttributes: resetIndent)
    }

}

private extension ExtendedStylingTextView {

    func anyAttributes(in range: NSRange, passTest body: ([String: Any]) -> Bool) -> Bool {
        var present = false
        textStorage.enumerateAttributes(in: range) { (attributes, range, stop) in
            guard body(attributes) else { return }
            present = true
            stop.pointee = true
        }
        return present
    }

    func toggleAttributes(isPresent: ([String: Any]) -> Bool = { _ in false }, adding add: (NSMutableAttributedString, inout NSRange) -> Void, removing remove: (NSMutableAttributedString, inout NSRange) -> Void, resetTypingAttributes: (inout [String: Any]) -> Void) {
        var range = selectedRange

        if textStorage.length == 0 || !anyAttributes(in: range, passTest: isPresent) {
            add(textStorage, &range)
        } else if anyAttributes(in: range, passTest: isPresent) {
            remove(textStorage, &range)
        }

        if range.length == 0 {
            resetTypingAttributes(&typingAttributes)
        }

        delegate?.textViewDidChange?(self)
    }

    private static let indentation: CGFloat = 36

    func increaseIndent(of text: NSMutableAttributedString, in range: inout NSRange) {
        range = (text.string as NSString).paragraphRange(for: range)
        text.enumerateAttribute(NSParagraphStyleAttributeName, in: range) { (paragraphStyle, range, _) in
            let newStyle = NSMutableParagraphStyle()
            (paragraphStyle as? NSParagraphStyle).map(newStyle.setParagraphStyle)

            newStyle.headIndent += ExtendedStylingTextView.indentation
            newStyle.firstLineHeadIndent += ExtendedStylingTextView.indentation

            text.addAttribute(NSParagraphStyleAttributeName, value: newStyle, range: range)
        }
    }

    func decreaseIndent(of text: NSMutableAttributedString, in range: inout NSRange) {
        range = (text.string as NSString).paragraphRange(for: range)
        text.enumerateAttribute(NSParagraphStyleAttributeName, in: range) { (paragraphStyle, range, _) in
            let newStyle = NSMutableParagraphStyle()
            (paragraphStyle as? NSParagraphStyle).map(newStyle.setParagraphStyle)

            newStyle.headIndent = max(0, newStyle.headIndent - ExtendedStylingTextView.indentation)
            newStyle.firstLineHeadIndent = max(0, newStyle.firstLineHeadIndent - ExtendedStylingTextView.indentation)

            text.addAttribute(NSParagraphStyleAttributeName, value: newStyle, range: range)
        }
    }

    func resetIndent(ofAttributes attributes: inout [String: Any]) {
        let newStyle = NSMutableParagraphStyle()
        if let currentStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
            newStyle.setParagraphStyle(currentStyle)
        }

        newStyle.headIndent = 0
        newStyle.firstLineHeadIndent = 0

        attributes[NSParagraphStyleAttributeName] = newStyle
    }

}
