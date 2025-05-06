/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit

extension Pose {
    
    struct Connection: Equatable {
        static let width: CGFloat = 12.0

        static let colors = [UIColor.systemGreen.cgColor, UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor, UIColor.systemRed.cgColor, UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor] as CFArray

        static let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB), colors: colors, locations: [0, 0.2, 0.33, 0.5, 0.66, 0.8])!

        private let point1: CGPoint
        private let point2: CGPoint
        
        init(_ one: CGPoint, _ two: CGPoint) { point1 = one; point2 = two }
        
        func drawToContext(_ context: CGContext, applying transform: CGAffineTransform? = nil, at scale: CGFloat = 1.0) {
            let start = point1.applying(transform ?? .identity)
            let end = point2.applying(transform ?? .identity)
            
            context.saveGState()
            defer { context.restoreGState() }
            context.setLineWidth(Connection.width * scale)

            context.move(to: start)
            context.addLine(to: end)
            context.replacePathWithStrokedPath()
            context.clip()
            context.drawLinearGradient(Connection.gradient, start: start, end: end, options: .drawsAfterEndLocation)
        }
    }
}

extension Pose {
    
    static let jointPairs: [(joint1: JointName, joint2: JointName)] = [
        (.leftShoulder, .leftElbow),
        (.leftElbow, .leftWrist),

        (.leftHip, .leftKnee),
        (.leftKnee, .leftAnkle),

        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist),

        (.rightHip, .rightKnee),
        (.rightKnee, .rightAnkle),

        (.leftShoulder, .neck),
        (.rightShoulder, .neck),
        (.leftShoulder, .leftHip),
        (.rightShoulder, .rightHip),
        (.leftHip, .rightHip)
    ]
}
