/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit
import Vision

extension Pose {
    typealias JointName = VNHumanBodyPoseObservation.JointName
    
    struct Landmark {
        private static let threshold: Float = 0.2
        private static let radius: CGFloat = 14.0
        
        let name: JointName
        let location: CGPoint
        
        init?(_ point: VNRecognizedPoint) {
            guard point.confidence >= Pose.Landmark.threshold else { return nil }
            name = JointName(rawValue: point.identifier)
            location = point.location
        }

        func drawToContext(_ context: CGContext, applying transform: CGAffineTransform? = nil, at scale: CGFloat = 1.0) {
            context.setFillColor(UIColor.white.cgColor)
            context.setStrokeColor(UIColor.darkGray.cgColor)
            
            let origin = location.applying(transform ?? .identity)
            let radius = Landmark.radius * scale
            let diameter = radius * 2
            let rectangle = CGRect(x: origin.x - radius, y: origin.y - radius, width: diameter, height: diameter)

            context.addEllipse(in: rectangle)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }
}
