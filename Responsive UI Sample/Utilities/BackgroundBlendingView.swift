//
//  BackgroundBlendingView.swift
//  Responsive UI Sample
//
//  Created by Zachary Waldowski on 6/11/17.
//  Copyright © 2017 Big Nerd Ranch. Licensed under MIT.
//

import UIKit

final class BackgroundBlendingView: UIView {

    private let visualEffectView: UIVisualEffectView
    private let blendingLayer: CALayer

    fileprivate init(effect: UIBlurEffect, tintColor: UIColor) {
        visualEffectView = UIVisualEffectView(effect: effect)

        blendingLayer = CALayer()
        blendingLayer.backgroundColor = tintColor.cgColor

        super.init(frame: .zero)

        addSubview(visualEffectView)
        layer.addSublayer(blendingLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        visualEffectView.frame = bounds
        blendingLayer.frame = layer.bounds
    }

}

extension BackgroundBlendingView {

    enum Effect {
        case statusBarLight
    }

    convenience init(effect: Effect) {
        switch effect {
        case .statusBarLight:
            self.init(effect: UIBlurEffect(style: .light), tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.82))
        }
    }

}
