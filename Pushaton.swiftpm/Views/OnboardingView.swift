//
//  OnboardingView.swift
//
//
//  Created by Wit Owczarek on 20/01/2024.
//

import Foundation
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var tabViewSelection: Int = 0
    var didSelectGetStarted: () -> Void
    
    init(didSelectGetStarted: @escaping () -> Void) {
        self.didSelectGetStarted = didSelectGetStarted
    }
}

struct OnboardingView {
    @StateObject var viewModel: OnboardingViewModel
}

extension OnboardingView: View {
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $viewModel.tabViewSelection) {
                
                Group {
                    OnboardingSlide(
                        title: "Welcome to Pushaton",
                        description: "Experience the fusion of calisthenics and gaming! Your real-life push-ups control the game – jump, run, and conquer the jungle.",
                        icon: {
                            Image("AppIconImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    )
                    .tag(0)
                    
                    OnboardingSlide(
                        title: "Real Life Controls",
                        description: "Run by holding a push-up down position. \nPerform push-ups to jump obstacles, then return to the down position to keep running. \n Master the rhythm of push-ups for an unstoppable jungle sprint!",
                        icon: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(Color.theme.primaryAccent.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(alignment: .center) {
                                    Image(systemName: "figure.taichi")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.theme.primaryAccent)
                                        .frame(width: 100, height: 100)
                                        .offset(x: 5)
                                }
                        }
                    )
                    .tag(1)
                    
                    OnboardingSlide(
                        title: "Quick Disclaimer",
                        description: "Although I did my best to ensure that the pushup classfication model is accurate, it isn't 100% perfect. Also note that prediction delays might be longer on older devices.",
                        icon: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(Color.red.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(alignment: .center) {
                                    Image(systemName: "square.stack.3d.up.trianglebadge.exclamationmark.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.red)
                                        .frame(width: 100, height: 100)
                                        .offset(x: 12)
                                }
                        }
                    )
                    .tag(2)
                    
                    OnboardingSlide(
                        title: "How To Play",
                        description: "Place your device 1-2m (4-7ft) away for full push-up capture. Ensure an unobstructed camera view for smooth gameplay. Assume a push-up position while focusing on the screen.",
                        icon: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(Color.theme.primaryAccent.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(alignment: .center) {
                                    Image(systemName: "list.bullet.clipboard")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.theme.primaryAccent)
                                        .frame(width: 100, height: 100)
                                }
                        }
                    )
                    .tag(3)
                }
                .padding(.bottom, 0.15 * UIScreen.main.bounds.height)
               
            }
            .tabViewStyle(.page)
            
            Button("Start Playing") {
                viewModel.didSelectGetStarted()
            }
            .buttonStyle(PrimaryButtonStyle(isDisabled: (viewModel.tabViewSelection != 3)))
            .disabled((viewModel.tabViewSelection != 3))
            .frame(maxWidth: 360, alignment: .bottom)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: UIScreen.main.bounds.size.height * 0.05, trailing: 16))
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.primaryAccent)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.theme.primaryAccent.opacity(0.25))
        }
    }
}

