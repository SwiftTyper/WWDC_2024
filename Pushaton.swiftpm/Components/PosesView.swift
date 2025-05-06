//
//  PosesView.swift
//
//
//  Created by Wit Owczarek on 15/12/2023.
//


import SwiftUI
import CreateMLComponents

struct PosesView: View {

    let poses: [Pose]

    var body: some View {
        Canvas { context, size in
            let pointTransform: CGAffineTransform =
                .identity
                .translatedBy(x: 0.0, y: -1.0)
                .concatenating(.identity.scaledBy(x: 1.0, y: -1.0))
                .concatenating(.identity.scaledBy(x: size.width, y: size.height))

            context.withCGContext { context in
                for pose in poses {
                    pose.drawWireframeToContext(context, applying: pointTransform)
                }
            }
        }
    }
}

struct PosesView_Previews: PreviewProvider {
    static var previews: some View {
        PosesView(poses: [])
    }
}
