//
//  SignalView.swift
//  SwiftSoinn
//
//  Created by Shuchen Du on 2016/07/10.
//  Copyright © 2016年 Shuchen Du. All rights reserved.
//

import UIKit


class SignalView: UIView {

    var graphicsContext: CGContextRef!
    
    var timer: NSTimer!
    
    var w: Float!
    var h: Float!
    var bw: Float!
    var bh: Float!
    
    var imgSignals: [Signal]!
    
    var image: UIImage!
    
    let soinn = Soinn()
    
    func setFillColor(r: Int, g: Int, b: Int) {
        
        CGContextSetRGBFillColor(graphicsContext, CGFloat(r), CGFloat(g), CGFloat(b), 1.0)
    }
    
    func setStrokeColor(r: Int, g: Int, b: Int) {
        
        CGContextSetRGBStrokeColor(graphicsContext, CGFloat(r), CGFloat(g), CGFloat(b), 1.0)
    }
    
    func fillCircle(x: Float, y: Float, r: Float) {
        
        CGContextFillEllipseInRect(graphicsContext, CGRectMake(CGFloat(x), CGFloat(y), CGFloat(r), CGFloat(r)))
        
    }
    
    func fillRect(x: Float, y: Float, w: Float, h: Float) {
        
        CGContextFillRect(graphicsContext, CGRectMake(CGFloat(x), CGFloat(y), CGFloat(w), CGFloat(h)))
    }
    
    func drawRect(x: Float, y: Float, w: Float, h: Float) {
        
        CGContextMoveToPoint(graphicsContext, CGFloat(x), CGFloat(y))
        CGContextAddLineToPoint(graphicsContext, CGFloat(x + w), CGFloat(y))
        CGContextAddLineToPoint(graphicsContext, CGFloat(x + w), CGFloat(y + h))
        CGContextAddLineToPoint(graphicsContext, CGFloat(x), CGFloat(y + h))
        CGContextAddLineToPoint(graphicsContext, CGFloat(x), CGFloat(y))
        CGContextAddLineToPoint(graphicsContext, CGFloat(x + w), CGFloat(y))
        CGContextStrokePath(graphicsContext)
    }
    
    func drawLine(x_from: Float, y_from: Float, x_to: Float, y_to: Float) {
        
        CGContextMoveToPoint(graphicsContext, CGFloat(x_from), CGFloat(y_from))
        CGContextAddLineToPoint(graphicsContext, CGFloat(x_to), CGFloat(y_to))
        CGContextStrokePath(graphicsContext)
    }
    
    func drawString(str: String, x: Float, y: Float, size: Float, color: UIColor) {
        
        let attrs = [
            NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(size)),
            NSForegroundColorAttributeName: color
        ]
        
        let nsstr = str as NSString
        
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)), withAttributes: attrs)
    }
    
    override func drawRect(rect: CGRect) {
        
        // get graphics context
        graphicsContext = UIGraphicsGetCurrentContext()
        
        // clear background
        clearBackground()
        
        // draw border
        drawBorder()
        
        // draw title
        drawTitle()
        
        // draw image
        //drawImage()
        
        // draw signal
        //drawSignal1()
        
        // draw image signal
        drawSignal2()
    }
    
    func drawImage() {
        
        image = UIImage(named: "logo.png")
        
        image.drawAtPoint(CGPointMake(80, 80))
    }
    
    func drawTitle() {
        
        drawString("input", x: 15, y: 33, size: 10, color: UIColor.redColor())
        drawString("number of signals: \(soinn.inSignals.count)", x: 80, y: 33, size: 10, color: UIColor.redColor())
        
        drawString("output", x: 15, y: bh + 43, size: 10, color: UIColor.redColor())
        drawString("number of signals: \(soinn.outSignals.count)", x: 80, y: bh + 43, size: 10, color: UIColor.redColor())
    }
    
    func drawBorder() {
    
        setStrokeColor(0, g: 0, b: 0)
        
        bw = w - 20
        bh = (h - 48) / 2
        
        drawRect(10, y: 28, w: bw, h: bh)
        drawRect(10, y: 38 + bh, w: bw, h: bh)
    }

    func clearBackground() {
        
        setFillColor(255, g: 255, b: 255)
        
        w = Float(self.frame.size.width)
        h = Float(self.frame.size.height)
        
        fillRect(0, y: 0, w: w, h: h)
    }
    
    func drawSignal1() {
        
        setFillColor(0, g: 0, b: 255)
        
        if timer == nil {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0/50.0, target: self, selector: "inputSignal1:", userInfo: nil, repeats: true)
        }
        
        for s in soinn.inSignals {
            
            fillCircle(s.x, y: s.y, r: 5)
        }
    }
    
    func inputSignal1(timer: NSTimer) {
        
        let xmin: Float = 10
        let xmax: Float = xmin + bw
        let ymin: Float = 28 + 20
        let ymax: Float = 28 + bh
        
        let (x, y) = getRandomXY(xmin, xmax: xmax, ymin: ymin, ymax: ymax)
        
        let signal = Signal(x: x, y: y)
        
        soinn.inSignals.append(signal)
        
        self.setNeedsDisplay()
    }
    
    
    func drawSignal2() {
        
        setFillColor(0, g: 0, b: 255)
        
        if timer == nil {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0/10000.0, target: self, selector: "inputSignal2:", userInfo: nil, repeats: true)
        }
        
        for s in soinn.inSignals {
            
            fillCircle(s.x - 26, y: s.y + 50, r: 3)
        }
        
        for s in soinn.outSignals {
        
            setFillColor((s.classID+1) * 50, g: 0, b: 255)
            
            fillCircle(s.x - 26, y: s.y + 350, r: 3)
        }
        
        for e in soinn.edges {
        
            //setStrokeColor(0, g: 255, b: e.from.classID * 50)
            
            drawLine(e.from.x - 26, y_from: e.from.y + 350, x_to: e.to.x - 26, y_to: e.to.y + 350)
        }
    }
    
    func inputSignal2(timer: NSTimer) {
        
        if image == nil {
            
            image = UIImage(named: "logo5.png")
        }
        
        if imgSignals == nil {
        
            imgSignals = image.filter()
        }
        
        if imgSignals.count == 0 {
        
            print("image singal is over...")
            return
        }
        
        let idx = getRandomIdx(0, max: Float(imgSignals.count - 1))
        
        if imgSignals.count != 0 {
            
            soinn.inputSignal(imgSignals[Int(idx)])
            
            imgSignals.removeAtIndex(Int(idx))
        }
        
        self.setNeedsDisplay()
    }
    
    func getRandomXY(xmin: Float, xmax : Float, ymin: Float, ymax : Float) -> (Float, Float) {
        
        let x = ( Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX) ) * (xmax - xmin) + xmin
        let y = ( Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX) ) * (ymax - ymin) + ymin
        
        return (x, y)
    }
    
    func getRandomIdx(min: Float, max : Float) -> Float {
        
        let idx = ( Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX) ) * (max - min) + min

        return idx
    }
}

extension UIImage {

    func filter() -> [Signal] {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data = CFDataGetBytePtr(pixelData)
        
        let w = Int(self.size.width)
        let h = Int(self.size.height)
        
        var signals = [Signal]()
        
        for y in 0..<h {
            
            for x in 0..<w {
                
                let pixelInfo = (x + y * w) * 4
                
                let r = data[pixelInfo]
                let g = data[pixelInfo+1]
                let b = data[pixelInfo+2]
                
                if r == g && g == b && b == 0 {
                    
                    let signal = Signal(x: Float(x), y: Float(y))
                    
                    signals.append(signal)
                }
            }
        }
        
        return signals
    }
}
