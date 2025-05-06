//
//  CameraOverlay.swift
//  
//
//  Created by Wit Owczarek on 14/12/2023.
//

import Foundation
import SwiftUI

struct CameraOverlay: View {
    
    @EnvironmentObject var viewModel: PredictionViewModel
    
    var body: some View {
        
        ZStack {
            if let (image, poses) = viewModel.currentFrame {
                CameraImageView(cameraImage: image)
                PosesView(poses: poses)
            } else {
                ProgressView()
            }
            
            if viewModel.countdownTimer != nil {
                Text(String(viewModel.countdownTime))
                    .font(.system(size: 196))
                    .bold()
                    .foregroundStyle(viewModel.getConditionCountdownColor())
                    .contentTransition(.numericText(countsDown: true))
                    .onAppear {
                        AudioPlayerManager.shared.playCountdownSound()
                    }
            }
        }
        .onAppear {
            viewModel.updateLabels(with: .startingPrediction)
        }
        .overlay(alignment: (viewModel.isShowingGame || viewModel.isGameOver) ? .bottomLeading : .top) {
            if viewModel.currentFrame != nil {
                if (viewModel.isShowingGame || viewModel.isGameOver) {
                    predictionLabels
                } else {
                    topBar
                }
            }
        }
        .frame(width: (viewModel.isShowingGame || viewModel.isGameOver) ? UIScreen.main.bounds.size.width/4 : UIScreen.main.bounds.size.width, height: (viewModel.isShowingGame || viewModel.isGameOver) ? UIScreen.main.bounds.size.height/4 : UIScreen.main.bounds.size.height)
        .containerShape(RoundedRectangle(cornerRadius: (viewModel.isShowingGame || viewModel.isGameOver) ? 30 : 0))
        .clipShape(RoundedRectangle(cornerRadius: (viewModel.isShowingGame || viewModel.isGameOver) ? 30 : 0))
        .padding(.leading, (viewModel.isShowingGame || viewModel.isGameOver) ? 10 : 0)
        .ignoresSafeArea(.all)
    }
  
}

extension CameraOverlay {
    
    var predictionLabels: some View {
        VStack(alignment: .center, spacing: 5){
            Text("Prediction: \(viewModel.predicted)")
                .font(.subheadline)
                .bold()
            
            Text("Confidence: \(viewModel.confidence)")
                .font(.caption)
        }
        .foregroundStyle(Color.theme.primaryText)
        .padding(10)
        .background(Material.ultraThin)
        .clipShape(ContainerRelativeShape())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 10)
    }
    
    var topBar: some View {
        VStack(alignment: .center, spacing: 10) {
            
            Label {
                Text("Enter Pushup Down Hold To Start")
            } icon: {
                Image(systemName: "flag.checkered.2.crossed")
            }
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.primaryText)
                
            HStack(alignment: .center, spacing: 10) {
                Text("Person Detected: ")
                    .font(.subheadline)
                    .foregroundStyle(Color.theme.primaryText)
                
                statusIndictator(viewModel.isPersonFullyDetected)
            }
        }
        .padding(30)
        .background(Material.ultraThinMaterial)
        .cornerRadius(50)
        .padding(.top, 40)
    }
    
    @ViewBuilder
    func statusIndictator(_ condition: Bool) -> some View {
        Image(systemName: condition ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundStyle(condition ? .green : .red)
            .font(.headline)
    }
}
