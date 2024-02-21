//
//  DrawingCanvasView.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-20.
//

import SwiftUI
import PencilKit

protocol DrawingDelegate: AnyObject {
    func didProduce(drawing: DrawingItem, sender: Any?)
}


struct DrawingCanvasView: View {
    @State private var canvas = PKCanvasView()
    
    var body: some View {
        CanvasView(canvas: $canvas)
    }
}

#Preview {
    DrawingCanvasView()
}

struct CanvasView: UIViewRepresentable {
    
   
    
   

    @Binding var canvas: PKCanvasView
    let toolPicker = PKToolPicker.init()
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var handler = DrawingHandler()
        
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            // Cancel the submission of the previous drawing when a user begins drawing
            // This lets the user draw another stroke without a time limit of 0.5 seconds
            handler.cancel()
        }
        
        /// Callback invoked when the canvasView's drawing has changed.
        ///
        /// This can occur in 1 of 2 situations:
        /// - The drawing was cleared or reset
        /// - New strokes have been added to the drawing
        ///
        /// - Parameter canvasView: The `CanvasView` instance used for drawing.
          func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
              handler.drawingChanged(canvasView)
        }

    }
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    
    func makeUIView(context: Context) -> some UIView {
        canvas.backgroundColor = .white
        canvas.isOpaque = false
        canvas.tool = PKInkingTool(.pen, color: .black, width: 20)
        canvas.delegate = context.coordinator
        canvas.drawingPolicy = .anyInput
        return  canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Toolpicker
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas) // Notify when the picker configuration changes
        canvas.becomeFirstResponder()
    }
    
    
    
    
   
}

/// Extension to `CGRect` that provides an easy way to calculate a rectangle's containing square
extension CGRect {
    /// The square that contains this rectangle with the centers being equal
    var containingSquare: CGRect {
        // Get the largest dimension
        let dimension = max(size.width, size.height)
        // Adjust each dimension accordingly
        // Note: One of these 2 insets is 0 because it corresponds to the largest dimension
        let xInset = (size.width - dimension) / 2
        let yInset = (size.height - dimension) / 2
        // Perform the inset to get the square
        return insetBy(dx: xInset, dy: yInset)
    }
}

class DrawingHandler {
    
    func cancel() {
        submitWorkItem?.cancel()
    }
    
    func drawingChanged(_ canvasView: PKCanvasView) {
        let drawingRect = canvasView.drawing.bounds
        guard drawingRect.size != .zero else {
            return
        }
        
        
        // Add a delay before submitting so the user can draw more strokes in this drawing
        // Create a `DispatchWorkItem` to submit the drawing after a delay
        submitWorkItem = DispatchWorkItem { [weak self] in
            self?.submitDrawing(canvasView: canvasView) }
        
        // Schedule the submission 0.5 second from now
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5, execute: submitWorkItem!)
    }
    
    /// Work item used to submit the drawing after a delay, in order to allow for drawings with multiple strokes
    var submitWorkItem: DispatchWorkItem?
    weak var delegate: DrawingDelegate?
    
    /// Submits the given drawing for further actions.
    ///
    /// Either the drawing is rendered into an image and updated in the View,
    /// or the drawing is classified and the corresponding sticker is added to the canvas.
    /// - Parameter canvasView: The `CanvasView` used for drawing.
    func submitDrawing(canvasView: PKCanvasView) {
        // Get the rectangle containing the drawing
        let drawingRect = canvasView.drawing.bounds.containingSquare
        // Turn the drawing into an image
        // Because this image may be displayed at a larger scale in the training view,
        // a scale of 2.0 is used for smooth rendering.
        let image = canvasView.drawing.image(from: drawingRect, scale: UIScreen.main.scale * 2.0)
        // Store the white tinted version and the rectangle in a drawing object
        let drawing = DrawingItem(image: image.cgImage!, rect: drawingRect)
        
        let predictorFeatures = ImagePredictor().getFeatures(image: image)
        print(predictorFeatures)
        
       // self.delegate?.didProduce(drawing: drawing, sender: self)
        
        DispatchQueue.main.async {
           // canvasView.drawing = PKDrawing()
        }
    }
    
}

