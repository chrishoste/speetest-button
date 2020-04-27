//
//  SpeedtestButtonView.swift
//  Custom-button
//
//  Created by Christophe Hoste on 26.04.20.
//  Copyright © 2020 Christophe Hoste. All rights reserved.
//

import UIKit

class SpeedtestButtonView: UIViewController {

    private let buttonView = UIView()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "GO"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()

    private lazy var buttonLayer = CALayer()
    private lazy var buttonCircle: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.innerBorder)
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = #colorLiteral(red: 0.1607843137, green: 0.7882352941, blue: 0.8078431373, alpha: 1)

        return shapeLayer
    }()

    private lazy var buttonBorderCircle: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.outterBorder)

        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = #colorLiteral(red: 0.1607843137, green: 0.7882352941, blue: 0.8078431373, alpha: 1)

        return shapeLayer

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(buttonView)
        buttonView.centerInSuperview()
        buttonView.constrainHeight(constant: 500)
        buttonView.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 32, bottom: 0, right: 32))

        setupButton()
    }

    private func setupButton() {
        view.layoutIfNeeded()
        buttonLayer.frame = buttonView.bounds.largestSquare
        buttonView.layer.addSublayer(buttonLayer)

        buttonLayer.addSublayer(buttonBorderCircle)
        buttonLayer.addSublayer(buttonCircle)

        buttonView.addSubview(label)
        label.centerInSuperview()

        animateButton()
    }

    private func animateButton() {

        let pulseAnimation = CABasicAnimation(keyPath: "path")
        pulseAnimation.fromValue = buttonCircle.path
        pulseAnimation.toValue = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.innerPulseTo)
        pulseAnimation.duration = Double.durationPulse
        pulseAnimation.autoreverses = true

        let scaleAnimation = CABasicAnimation(keyPath: "path")
        scaleAnimation.fromValue = buttonBorderCircle.path
        scaleAnimation.toValue = Utils.pathForCircleInRect(rect: buttonLayer.bounds,
                                                           scaled: CGFloat.outterBorderScaleTo)
        scaleAnimation.duration = Double.durationscaleOpaciy
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.timingFunction = .init(name: .easeOut)

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = Double.durationscaleOpaciy
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = .init(name: .easeOut)

        let buttonCircleGroup = CAAnimationGroup()
        buttonCircleGroup.animations = [pulseAnimation]
        buttonCircleGroup.duration = Double.delayGroup
        buttonCircleGroup.repeatCount = .infinity
        buttonCircle.add(buttonCircleGroup, forKey: "pulse")

        let buttonBorderGroup = CAAnimationGroup()
        buttonBorderGroup.animations = [scaleAnimation, opacityAnimation]
        buttonBorderGroup.duration = Double.delayGroup
        buttonBorderGroup.beginTime = CACurrentMediaTime() + Double.delay
        buttonBorderGroup.repeatCount = .infinity
        buttonBorderCircle.add(buttonBorderGroup, forKey: "scaleOpacity")
    }
}
