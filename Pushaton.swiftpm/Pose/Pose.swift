/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//
//  Pose.swift
//
//
//  Modified by Wit Owczarek on 16/12/2023.
//

import UIKit
import Vision

typealias Observation = VNHumanBodyPoseObservation

struct Pose {
    private let landmarks: [Landmark]
    private var connections: [Connection]!

    let multiArray: MLMultiArray
    let observation: Observation
    let area: CGFloat
    

    init?(_ observation: Observation) {
        landmarks = observation.availableJointNames.compactMap { jointName in
            guard jointName != JointName.root else { return nil }
            guard let point = try? observation.recognizedPoint(jointName) else { return nil }
            return Landmark(point)
        }
        guard !landmarks.isEmpty else { return nil }
        
        self.observation = observation
        
        area = Pose.areaEstimateOfLandmarks(landmarks)
        multiArray = Pose.getMinimalMultiArray(observation: observation)
        buildConnections()
    }
    
    static func fromObservations(_ observations: [Observation]?) -> [Pose]? {
        observations?.compactMap { observation in Pose(observation) }
    }
    
    func hasNecessaryKeypoints() -> Bool {
        let requiredBodyParts: [JointName] = [.leftShoulder, .rightShoulder, .nose, .leftWrist, .rightWrist, .leftElbow, .rightElbow]
        let allBodyPartsDetected = requiredBodyParts.allSatisfy { bodyPart in
            guard let _ = self.landmarks.firstIndex(where: { $0.name == bodyPart }) else {
                return false
            }
            return true
        }
        return allBodyPartsDetected
    }
    
    static func getMinimalMultiArray(observation: Observation) -> MLMultiArray {
        guard let multiArray = try? MLMultiArray(shape: [NSNumber(value: 1), NSNumber(value: 1), NSNumber(value: 16)], dataType: .float32) else {
            fatalError("Couldn't create multiArray")
        }
        
        let requiredBodyParts: [JointName] = [.rightElbow , .leftElbow, .leftWrist, .rightWrist, .rightShoulder, .leftShoulder, .neck, .nose]
        
        guard let recognizedPoints = try? observation.recognizedPoints(forGroupKey: .all) else {
            return multiArray
        }
        
        var index: Int = 0
        
        for bodyPart in requiredBodyParts {
            guard let point = recognizedPoints[bodyPart.rawValue] else {
                index += 2
                continue
            }
            multiArray[index] = NSNumber(value: point.x)
            multiArray[index+1] = NSNumber(value: point.y)
            index+=2
        }
        
        return multiArray
    }
    
    func drawWireframeToContext(_ context: CGContext, applying transform: CGAffineTransform? = nil) {
        let scale = drawingScale
        
        connections.forEach {
            line in line.drawToContext(context, applying: transform, at: scale)
        }

        landmarks.forEach { landmark in
            landmark.drawToContext(context, applying: transform, at: scale)
        }
    }

    private var drawingScale: CGFloat {
        let typicalLargePoseArea: CGFloat = 0.35
        let max: CGFloat = 1.0
        let min: CGFloat = 0.6
        let ratio = area / typicalLargePoseArea
        let scale = ratio >= max ? max : (ratio * (max - min)) + min
        return scale
    }
}

extension Pose {
    
    mutating func buildConnections() {
        guard connections == nil else { return }
        connections = [Connection]()
        
        let joints = landmarks.map { $0.name }
        let locations = landmarks.map { $0.location }
        let zippedPairs = zip(joints, locations)
        let jointLocations = Dictionary(uniqueKeysWithValues: zippedPairs)
        
        for jointPair in Pose.jointPairs {
            guard let one = jointLocations[jointPair.joint1] else { continue }
            guard let two = jointLocations[jointPair.joint2] else { continue }

            connections.append(Connection(one, two))
        }
    }

    static func areaEstimateOfLandmarks(_ landmarks: [Landmark]) -> CGFloat {
        let xCoordinates = landmarks.map { $0.location.x }
        let yCoordinates = landmarks.map { $0.location.y }

        guard let minX = xCoordinates.min() else { return 0.0 }
        guard let maxX = xCoordinates.max() else { return 0.0 }

        guard let minY = yCoordinates.min() else { return 0.0 }
        guard let maxY = yCoordinates.max() else { return 0.0 }

        let deltaX = maxX - minX
        let deltaY = maxY - minY

        return deltaX * deltaY
    }
}
