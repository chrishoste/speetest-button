//
//  Extensions.swift
//  Custom-button
//
//  Created by Christophe Hoste on 26.04.20.
//  Copyright © 2020 Christophe Hoste. All rights reserved.
//

import UIKit
import QuartzCore

public extension CGRect {

    init(centre: CGPoint, size: CGSize) {
        self.init(origin: centre.applying(CGAffineTransform(translationX: size.width / -2, y: size.height / -2)),
                  size: size)
    }

    var centre: CGPoint {
        return .init(x: midX, y: midY)
    }

    var largestSquare: CGRect {
        let smallestSide = min(width, height)
        return CGRect(centre: centre, size: .init(width: smallestSide, height: smallestSide))
    }
}

public extension CGSize {
    func rescale(_ scale: CGFloat) -> CGSize {
        return applying(CGAffineTransform(scaleX: scale, y: scale))
    }
}

public struct Utils {

    public static func pathForCircleInRect(rect: CGRect, scaled: CGFloat) -> CGPath {
        let size = rect.size.rescale(scaled)

        return UIBezierPath(ovalIn: CGRect(centre: rect.centre, size: size)).cgPath
    }
}

extension CGFloat {
    static let innerBorder: CGFloat = 0.6
    static let innerPulseTo: CGFloat = innerBorder - 0.01

    static let outterBorder: CGFloat = innerBorder - 0.05
    static let outterBorderScaleTo: CGFloat = outterBorder + 0.3

    static let maskPath: CGFloat = innerBorder + 0.02

    static let spinnerScale: CGFloat = 0.8
    static let spinnerInnerScale: CGFloat = spinnerScale - 0.02
}

extension Double {
    static let durationPulse: Double = 0.2
    static let durationscaleOpaciy: Double = 2
    static let delay: Double = durationPulse / 2
    static let delayGroup: Double = 3 + durationPulse

    static let durationSpinnerScale: Double = 0.3
}
