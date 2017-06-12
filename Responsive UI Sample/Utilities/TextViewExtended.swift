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
    func toggleListDash(_ sender: Any?)
    func toggleListNumber(_ sender: Any?)
    func toggleListBullet(_ sender: Any?)
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

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case _ where inhibitsSelectionCommands && sender is UIMenuController:
            return false
        case #selector(ResponderExtendedStylingActions.toggleStrikethrough),
             #selector(ResponderExtendedStylingActions.toggleListDash), #selector(ResponderExtendedStylingActions.toggleListBullet), #selector(ResponderExtendedStylingActions.toggleListNumber),
             #selector(ResponderExtendedStylingActions.increaseIndent), #selector(ResponderExtendedStylingActions.decreaseIndent):
            return isFirstResponder && isEditable ? allowsEditingTextAttributes : false
        case _ where String(describing: action).hasSuffix("showTextStyleOptions:"),
             #selector(UIResponder.toggleBoldface), #selector(UIResponder.toggleItalics), #selector(UIResponder.toggleUnderline):
            return sender is UIMenuController ? false : super.canPerformAction(action, withSender: sender)
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }

    //// STOPPING POINT:
    //// IMPLEMENT THESE

    @objc func toggleStrikethrough(_ sender: Any?) {
        print(#function)
    }

    @objc func toggleListDash(_ sender: Any?) {
        print(#function)
    }

    @objc func toggleListNumber(_ sender: Any?) {
        print(#function)
    }

    @objc func toggleListBullet(_ sender: Any?) {
        print(#function)
    }

    @objc func increaseIndent(_ sender: Any?) {
        print(#function)
    }

    @objc func decreaseIndent(_ sender: Any?) {
        print(#function)
    }

}
