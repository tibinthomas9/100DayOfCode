//
//  DrawingItem.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-20.
//

import UIKit

import Vision
import CoreML
import CoreImage

/// Convenience structure that stores a drawing's `CGImage`
/// along with the `CGRect` in which it was drawn on the `PKCanvasView`
/// - Tag: Drawing
struct DrawingItem {
    private static let ciContext = CIContext()
    
    /// The underlying image of the drawing.
    let image: CGImage
    
    /// Rectangle containing this drawing in the canvas view
    let rect: CGRect
    
    
    
    private var whiteTintedImage: CGImage {
        let ciContext = DrawingItem.ciContext
        
        let parameters = [kCIInputBrightnessKey: 1.0]
        let ciImage = CIImage(cgImage: image).applyingFilter("CIColorControls",
                                                             parameters: parameters)
        return ciContext.createCGImage(ciImage, from: ciImage.extent)!
    }
    
    
}

class ImagePredictor {
    var categories: [String: VNConfidence] = [:]
    var searchTerms: [String: VNConfidence] = [:]
    
    func getFeatures(image: UIImage) -> [String] {
        // Classify the images
        
        guard let ciImage = CIImage(image: image) else {
            print("Error converting UIImage to CIImage")
            return []
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        let request = VNClassifyImageRequest()
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        // Process classification results
        guard let observations = request.results else {
            categories = [:]
            searchTerms = [:]
            return []
        }

        categories = observations
            .filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }
            .reduce(into: [String: VNConfidence]()) { dict, observation in dict[observation.identifier] = observation.confidence }
        
//        searchTerms = observations
//            .filter { $0.hasMinimumPrecision(0.01, forRecall: 0.7) }
//            .reduce(into: [String: VNConfidence]()) { (dict, observation) in dict[observation.identifier] = observation.confidence }
        
        let keys: [String] =  categories.keys.map { item in
            item
        }
        return keys
    }
}

