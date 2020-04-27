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
    static var innerBorder: CGFloat = 0.6
    static var innerPulseTo: CGFloat = innerBorder - 0.01
    static var outterBorder: CGFloat = innerBorder - 0.05
    static var outterBorderScaleTo: CGFloat = outterBorder + 0.3
}

extension Double {
    static var durationPulse: Double = 0.2
    static var durationscaleOpaciy: Double = 2
    static var delay: Double = durationPulse / 2
    static var delayGroup: Double = 3 + durationPulse
}
