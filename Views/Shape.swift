//
//  Shape.swift
//  Dough
//
//  Created by Miriam Hendler on 7/31/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class Shape: UIView {
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        let mask = CAShapeLayer()
        mask.frame = self.layer.bounds
        
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height
        
        let path = CGPathCreateMutable()
        
        
        //changes slantyness
        CGPathMoveToPoint(path, nil, 0, 270 - 230)
        CGPathAddLineToPoint(path, nil, width, 0)
        CGPathAddLineToPoint(path, nil, width, height + 270)
        CGPathAddLineToPoint(path, nil, 0, height + 200)
        CGPathAddLineToPoint(path, nil, 0, 270)
        
        mask.path = path
        
        // CGPathRelease(path); - not needed
        
        self.layer.mask = mask
        
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = path
        shape.lineWidth = 0
        shape.strokeColor = UIColor.whiteColor().CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        
        self.layer.insertSublayer(shape, atIndex: 0)
        
    }

}
