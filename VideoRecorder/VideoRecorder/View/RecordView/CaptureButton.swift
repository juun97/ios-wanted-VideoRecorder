//
//  CaptureButton.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/09.
//

import UIKit

@IBDesignable
class CaptureButton: UIButton {
    
    var isPlay = false
      
      override func draw(_ rect: CGRect) {
          guard let context = UIGraphicsGetCurrentContext() else {
              return
          }
             
          let outerCircleRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
          let innerCircleRect = bounds.insetBy(dx: bounds.width * 0.2, dy: bounds.height * 0.2)
          let rectangleRect = bounds.insetBy(dx: bounds.width * 0.26, dy: bounds.height * 0.26)
         
          context.beginPath()
          context.setLineWidth(4)
          context.setStrokeColor(UIColor.white.cgColor)
          context.addEllipse(in: outerCircleRect)
          context.drawPath(using: .stroke)
          context.closePath()
          
          if isPlay {
              context.beginPath()
              context.addRect(rectangleRect)
              context.setFillColor(UIColor.red.cgColor)
              context.drawPath(using: .fill)
              context.closePath()
              
          } else {
              context.beginPath()
              context.addEllipse(in: innerCircleRect)
              context.setFillColor(UIColor.red.cgColor)
              context.drawPath(using: .fill)
              context.closePath()
              
          }
      }
}

