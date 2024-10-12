# Pushaton - Swift Student Challenge Submission

## Overview
Pushaton is a fitness game that combines physical exercise (specifically pushups) with engaging gameplay. It was developed for the Swift Student Challenge, showcasing the integration of ML & Apple Frameworks with health-promoting activities.

https://github.com/user-attachments/assets/c6b090f8-3171-4060-9d7d-3a518ec3adc2

## Features
- **Fitness-Gaming Fusion**: Transform pushups into an interactive gaming experience.
- **2D Side-Scrolling Environment**: Utilizes SpriteKit to create an immersive jungle setting.
- **Real-time Motion Detection**: Employs VisionKit and a live camera feed to capture and extract player body keypoints.
- **Custom Deep Learning Model**: Used to analyze player movement, determining the pushup state.
- **Engaging Audio-Visual Experience**: Custom graphics and sound effects. (Neither graphics nor audio were created by me)

## Technologies Used:
- Swift
- Combine
- SpriteKit
- VisionKit
- CoreML
- AVFoundation
- Python + TensorFlow (for model development)
- coremltools (for model conversion)
    
## Gameplay
- https://www.youtube.com/watch?v=ITtNIRsvdsQ

## Development Challenges 
- **Improving model accuracy while maintaining real-time performance**:
  - Gathered over 80,000 pushup images.
  - Started with 3D CNNs, explored transfer learning and Dense Optical Flow.
  - 1.5 months spent creating 20+ model versions.
  - Final solution: LSTM model trained on body position points obtained from VisionKit. (87.3% test accuracy)
