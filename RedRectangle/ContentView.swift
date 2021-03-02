//
//  ContentView.swift
//  RedRectangle
//
//  Created by Danilo Cazaroto de Oliveira on 2021/02/24.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Variables
    @State private var actualColor: Color = Color.red {
        willSet {
            lastColor = actualColor
        }
    }
    @State private var isDragging: Bool = false
    @State private var lastColor: Color = Color.red
    @State private var originalLocation: CGPoint = CGPoint(x: 50, y: 50)
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    @GestureState private var isDetectedLongPress: Bool = false
    @State private var currentMagnification: CGFloat = 1
    @GestureState private var pinchMagnification: CGFloat = 1
    @State private var currentRotation = Angle.zero
    @GestureState private var twistAngle = Angle.zero
    
    //MARK: - View
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                roundedRectangle
                    .fill(actualColor)
                    .frame(width: 100, height: 100)
                    .rotationEffect(currentRotation + twistAngle)
                    .scaleEffect(currentMagnification * pinchMagnification)
                    .position(location)
                    .gesture(doubleTap)
                    .gesture(tap)
                    .gesture(longPress)
                    .gesture(drag)
                    .gesture(pinch)
                    .simultaneousGesture(rotation)
                        
                resetButon
                    .frame(width: geometry.size.width / 2, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .position(x: geometry.size.width * 0.10 , y: geometry.size.height * 0.95)
                    .buttonStyle(PlainButtonStyle())

            }
            .onAppear {
                self.location = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                self.originalLocation = self.location
            }
        }
    }
    
    //MARK: - Gestures Variables
    
    // Tap Gesture
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded {
                withAnimation{
                    if actualColor == Color.red {
                        actualColor = Color.blue
                    } else {
                        actualColor = Color.red
                    }
                }
            }
    }
    
    //Double Tap Gesture
    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    if(actualColor != Color.yellow) {
                        actualColor = Color.yellow
                    } else {
                        actualColor = lastColor
                    }
                }
            }
    }
    
    //Drag Gesture
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                self.location = value.location
            }
            .onEnded { _ in self.isDragging = false }
    }
    
    //LongPress Gesture
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating ($isDetectedLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded{ finished in
                withAnimation {
                    if(actualColor != Color.green) {
                        actualColor = Color.green
                    } else {
                        actualColor = lastColor
                    }
                }
            }
    }
    
    //Magnification Gesture
    var pinch: some Gesture {
        MagnificationGesture()
            .updating($pinchMagnification) { (value, state, _ ) in
                state = value
            }
            .onEnded{ self.currentMagnification *= $0 }
    }
    
    //Rotation Gesture
    var rotation: some Gesture {
        RotationGesture()
            .updating($twistAngle) { (value, state, _ ) in
                state = value
            }
            .onEnded{ self.currentRotation += $0 }
    }
    
    //MARK: - Functions
    private func reset() -> Void {
        withAnimation{
            self.currentMagnification = CGFloat(1)
            self.currentRotation = Angle.zero
            self.actualColor = Color.red
            self.location = self.originalLocation
        }
    }
}

extension ContentView {
    
    private var roundedRectangle: RoundedRectangle {
        RoundedRectangle(cornerRadius: 20)
    }
    
    private var resetButon: some View {
        Button(action: reset){
            Text("Reset")
                .font(.system(size: 15))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    //MARK: - Preview
    static var previews: some View {
        ContentView()
    }
}
