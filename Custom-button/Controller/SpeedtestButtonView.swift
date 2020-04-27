//
//  SpeedtestButtonView.swift
//  Custom-button
//
//  Created by Christophe Hoste on 26.04.20.
//  Copyright © 2020 Christophe Hoste. All rights reserved.
//

import UIKit

class SpeedtestButtonView: UIViewController {

    private var toggle = false

    private let buttonView = UIView()
    private let labelView = UIView()
    private var labelViewWidth = NSLayoutConstraint()

    private lazy var labelGO: UILabel = {
        let label = UILabel()
        label.text = "GO"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()

    private lazy var labelConnecting: UILabel = {
        let label = UILabel()
        label.text = "Connecting..."
        label.font = .systemFont(ofSize: 26, weight: .regular)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
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

    private lazy var maskLayer: CAShapeLayer = {
        let mask = CAShapeLayer()
        mask.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.maskPath)
        return mask
    }()

    private lazy var spinnerLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.type = .conic

        gradientLayer.colors = [UIColor.clear, #colorLiteral(red: 0.1607843137, green: 0.7882352941, blue: 0.8078431373, alpha: 1).withAlphaComponent(0.5), #colorLiteral(red: 0.1607843137, green: 0.7882352941, blue: 0.8078431373, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.7882352941, blue: 0.8078431373, alpha: 1)].map {$0.cgColor}
        gradientLayer.locations = [0, 0.1, 0.15, 1]
        gradientLayer.frame = CGRect(centre: buttonLayer.bounds.centre,
                                     size: buttonLayer.bounds.size)

        gradientLayer.mask = maskLayer

        gradientLayer.isHidden = true
        return gradientLayer
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
        setupGesture()
    }

    private func setupButton() {
        view.layoutIfNeeded()
        buttonLayer.frame = buttonView.bounds.largestSquare
        buttonView.layer.addSublayer(buttonLayer)

        buttonLayer.addSublayer(buttonBorderCircle)
        buttonLayer.addSublayer(spinnerLayer)
        buttonLayer.addSublayer(buttonCircle)

        buttonView.addSubview(labelView)
        labelView.centerInSuperview()
        labelView.constrainHeight(constant: 200)
        labelViewWidth = labelView.widthAnchor.constraint(equalToConstant: 200)
        labelViewWidth.isActive = true
        setupLabels()
        pulseAnimation()
    }

    private func setupLabels() {
        labelView.clipsToBounds = true
        labelView.addSubview(labelGO)
        labelGO.centerInSuperview()
        labelGO.anchor(top: nil, leading: labelView.leadingAnchor, bottom: nil, trailing: labelView.trailingAnchor)

        labelView.addSubview(labelConnecting)
        labelConnecting.centerInSuperview()
        labelConnecting.anchor(top: nil, leading: labelView.leadingAnchor,
                               bottom: nil, trailing: labelView.trailingAnchor)

        labelView.layoutIfNeeded()
        labelConnecting.transform = CGAffineTransform(translationX: labelConnecting.frame.width, y: 0)
    }

    private func animateLabels(_ reset: Bool = false) {
        if reset {
            labelViewWidth.constant = buttonView.bounds.size.rescale(0.5).width
            UIView.animate(withDuration: Double.durationSpinnerScale, delay: 0, animations: { [weak self] in
                guard let self = self else {
                    return
                }
                self.labelConnecting.transform = CGAffineTransform(translationX: self.labelConnecting.frame.width, y: 0)
                self.labelGO.transform = .identity
            })
        } else {
            labelViewWidth.constant = buttonView.bounds.size.rescale(0.7).width
            UIView.animate(withDuration: Double.durationSpinnerScale, delay: 0, animations: { [weak self] in
                guard let self = self else {
                    return
                }
                self.labelConnecting.transform = .identity
                self.labelGO.transform = CGAffineTransform(translationX: -self.labelGO.frame.width, y: 0)
            })
        }
    }

    private func spinnerAnimation() {
        animateLabels()
        buttonCircle.removeAnimation(forKey: "pulse")
        buttonBorderCircle.removeAnimation(forKey: "scaleOpacity")

        buttonCircle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        spinnerLayer.isHidden = false

        let spinnerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinnerAnimation.fromValue = 0
        spinnerAnimation.toValue = 2 * Double.pi
        spinnerAnimation.duration = 1
        spinnerAnimation.repeatCount = .infinity
        spinnerLayer.add(spinnerAnimation, forKey: "spinner")

        let scaleAnimation = CABasicAnimation(keyPath: "path")
        scaleAnimation.fromValue = maskLayer.path
        scaleAnimation.toValue = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.spinnerScale)
        scaleAnimation.duration = Double.durationSpinnerScale
        scaleAnimation.timingFunction = .init(name: .easeOut)

        maskLayer.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.spinnerScale)
        maskLayer.add(scaleAnimation, forKey: "mask")

        let scaleInnerAnimation = CABasicAnimation(keyPath: "path")
        scaleInnerAnimation.fromValue = buttonCircle.path
        scaleInnerAnimation.toValue = Utils.pathForCircleInRect(rect: buttonLayer.bounds,
                                                                scaled: CGFloat.spinnerInnerScale)
        scaleInnerAnimation.duration = Double.durationSpinnerScale
        scaleInnerAnimation.timingFunction = .init(name: .easeOut)

        buttonCircle.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.spinnerInnerScale)
        buttonCircle.add(scaleInnerAnimation, forKey: "path")

    }

    private func resetToPulse() {
        animateLabels(true)
        buttonCircle.strokeColor = #colorLiteral(red: 0.1607843137, green: 0.7882352941, blue: 0.8078431373, alpha: 1)

        buttonCircle.removeAnimation(forKey: "path")
        spinnerLayer.removeAnimation(forKey: "spinner")
        maskLayer.removeAnimation(forKey: "mask")

        let scaleAnimation = CABasicAnimation(keyPath: "path")
        scaleAnimation.fromValue = maskLayer.path
        scaleAnimation.toValue = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.innerBorder)
        scaleAnimation.duration = Double.durationSpinnerScale
        scaleAnimation.timingFunction = .init(name: .easeOut)

        spinnerLayer.isHidden = true
        maskLayer.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.maskPath)
        maskLayer.add(scaleAnimation, forKey: "mask")

        let scaleInnerAnimation = CABasicAnimation(keyPath: "path")
        scaleInnerAnimation.fromValue = buttonCircle.path
        scaleInnerAnimation.toValue = Utils.pathForCircleInRect(rect: buttonLayer.bounds,
                                                               scaled: CGFloat.innerBorder)
        scaleInnerAnimation.duration = Double.durationSpinnerScale
        scaleInnerAnimation.timingFunction = .init(name: .easeOut)

        buttonCircle.path = Utils.pathForCircleInRect(rect: buttonLayer.bounds, scaled: CGFloat.innerBorder)
        buttonCircle.add(scaleInnerAnimation, forKey: "path")

        pulseAnimation()
    }

    private func pulseAnimation() {

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

    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        buttonView.addGestureRecognizer(gesture)

    }

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {

        if toggle {
            resetToPulse()
        } else {
            spinnerAnimation()
        }

        toggle = !toggle
    }
}
