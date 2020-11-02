//
//  ImageTranscodingView.swift
//  Floatr-SwiftUI
//
//  Created by Tyson Parks on 2020-10-26.
//  Copyright © 2020 Tyson Parks. All rights reserved.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
//import AVFoundation


// MARK: - ImageTranscodingView
struct ImageTranscodingView: View {
  //  @State private var textInput: String = ""
  @State private var url: URL = TestData.gif12FPS
  @State private var inputImageData: Data?
  @State private var outputImageData: Data?
  @State private var outputImage: SDAnimatedImage?
  
  @State private var conversionSuccess: String = "Give it a try!"
  
  init() {
    let url = self.url
    self.inputImageData = try! Data(contentsOf: url)
  }
  
  var body: some View {
    ZStack {
      VStack {
        
        HStack {
          Button("gif \n12.5fps") { self.loadImage(url: TestData.gif12FPS) }
          Spacer()
          Button("apng \n9fps") { self.loadImage(url: TestData.apng9FPS) }
          Spacer()
          Button("apng \n12fps") { self.loadImage(url: TestData.apng12FPS) }
          Spacer()
          Button("apng \n30fps") { self.loadImage(url: TestData.apng30FPS) }
        }
        .padding(.horizontal)
        
        AnimatedImageInfoView(data: $inputImageData)

        HStack {
          Text("Convert to: ")
          Button("HEIC") { convertImage(to: .HEIC) }
          Button("APNG") { convertImage(to: .PNG) }
          Button("GIF") { convertImage(to: .GIF) }
        }
        .padding()
        
        AnimatedImageInfoView(data: $outputImageData)
        
        Spacer()
        
        Text("Status: \(conversionSuccess)")
          .padding()
      }
    }
  }
}

// MARK: computed
extension ImageTranscodingView {
  private func loadImage(url: URL) {
    self.inputImageData = try! Data(contentsOf: url)
  }
  
  private func convertImage(to format: SDImageFormat) {
    guard inputImageData != nil else { return }
    guard let imageFromData = SDAnimatedImage(data: inputImageData!) else {
      conversionSuccess = "imageFromData failed 🙁"
      return
    }
    
    if let output: Data = imageFromData.sd_imageData(as: format, compressionQuality: 10) {
      conversionSuccess = "Conversion to \(format.name) successful 🥳"
      outputImageData = output
      outputImage = SDAnimatedImage(data: outputImageData!)
    } else {
      conversionSuccess = "Conversion to \(format.name) failed 😖"
    }
  }
}

// MARK: - SDAnimatedImage+Properties
extension SDAnimatedImage {
  //  var frames: [SDImageFrame]? {
  //    guard let images = self.images else { return nil }
  //    let count = Int(self.animatedImageFrameCount)
  //
  //    let frames = (0..<count).map { index in
  //      SDImageFrame(image: images[index], duration: self.durations[index])
  //    }
  //    return frames
  //  }
  //
  //  open override var images: [UIImage]? {
  //    let retrievedImages = (0..<self.animatedImageFrameCount)
  //      .map { self.animatedImageFrame(at: $0) ?? nil }
  //      .compactMap{ $0 }
  //
  //    if retrievedImages.count == self.animatedImageFrameCount {
  //      return retrievedImages
  //    } else {
  //      return nil
  //    }
  //  }
  //
  //  var durations: Array<TimeInterval> {
  //    (0..<self.animatedImageFrameCount).map {
  //      self.animatedImageDuration(at: $0)
  //    }
  //  }
  
  var totalDuration: TimeInterval {
    (0..<self.animatedImageFrameCount).reduce(0) {
      $0 + self.animatedImageDuration(at: $1)
    }
  }
  
  var avgFPS: Double {
    Double(self.animatedImageFrameCount) / self.totalDuration
  }
  
  //  var avgFrameDuration: TimeInterval {
  //    1.0 / avgFPS
  //  }
  
  //  var minDuration: TimeInterval? { durations.min() }
  //  var maxDuration: TimeInterval? { durations.max() }
  //
  //  var hasConstantFramerate: Bool {
  //    minDuration != nil && minDuration == maxDuration
  //  }
}


// MARK: -
// MARK: - ImageCodingTests_Previews
struct ImageCodingTests_Previews: PreviewProvider {
  static var previews: some View {
    ImageTranscodingView()
      .preferredColorScheme(.dark)
  }
}

// MARK: - SDImageFormat+
extension SDImageFormat {
  var name: String {
    switch self {
    case .GIF:
      return "gif"
    case .HEIC:
      return "heic"
    case .HEIF:
      return "heif"
    case .JPEG:
      return "jpg"
    case .PDF:
      return "pdf"
    case .PNG:
      return "png"
    case .SVG:
      return "svg"
    case .TIFF:
      return "tiff"
    case .undefined:
      return "undefined"
    case .webP:
      return "webP"
    default:
      return "unknown"
    }
  }
}

// MARK: - AnimatedImageInfoView
struct AnimatedImageInfoView: View {
  @Binding var data: Data?
  private var infoString: String {
    imageInfo(imageData: data)
  }
  
  var body: some View {
    HStack {
      if data != nil {
        AnimatedImage(data: data!, isAnimating: Binding.constant(true))
          .maxBufferSize(.max)
          .playbackRate(1)
          .resizable()
          .scaledToFit()
        
        
      } else {
        Image(systemName: "questionmark.square")
          .resizable()
          .font(Font.title.weight(.ultraLight))
          .scaledToFit()
      }
      
      
      Text(infoString)
        .padding()
      
      Spacer()
    }
    .padding(.horizontal)
  }
  
  func imageInfo(imageData: Data?) -> String {
    guard imageData != nil else { return "" }
    if let animatedImage = SDAnimatedImage(data: imageData!) {
      let format = animatedImage.animatedImageFormat.name
      let frameCount = animatedImage.animatedImageFrameCount.description
      let duration = String(format: "%.2f", animatedImage.totalDuration)
      let fps = String(format: "%.2f", animatedImage.avgFPS)
      let width = Int(animatedImage.size.width)
      let height = Int(animatedImage.size.height)
      
      let infoString: String = "\(format) format \n\(frameCount) frames \n\(duration) sec \n\(fps) fps \n\(width)x\(height) pix"
      
      return infoString
    }
    return ""
  }
}

struct TestData {
  static let apng9FPS = URL(string: "https://static1.squarespace.com/static/551b39a7e4b0a26ceee7f942/t/5fa0650653d6171155726884/1604347151559/GrafittiWave-32fr-500p-9fps-APNG-.png")!
  static let apng12FPS = URL(string: "https://static1.squarespace.com/static/551b39a7e4b0a26ceee7f942/t/5f9ca87c5578154aa84dedf5/1604102291616/FishOutOfWater-30fr-1000p-12fps-OptimAPNGb-APNG.png")!
  static let apng30FPS = URL(string: "https://static1.squarespace.com/static/551b39a7e4b0a26ceee7f942/t/5f9c900ea9de857a7a2e3950/1604096045555/Lofty_TysonParks_APNG.png")!
  static let gif12FPS = URL(string: "https://66.media.tumblr.com/83760a1ca72ce8f513ec2128bf454f9c/tumblr_n71emyMJKl1qcc8dao1_500.gifv")!
}




