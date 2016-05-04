//
//  PauseButton.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class PauseButton: UIControl {
    
    private var _buttonRect: CGRect = CGRectZero
    var _pressed: Bool = false
    
    //Register Touch
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        sendActionsForControlEvents(UIControlEvents.AllEvents)
    }
    
    
    //Draws The PauseButton
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        self.backgroundColor = UIColor.clearColor()
        
        //Joystick size/location
        _buttonRect = CGRectZero
        _buttonRect.size.width = bounds.width
        _buttonRect.size.height = bounds.height
        _buttonRect.origin.x = bounds.origin.x
        _buttonRect.origin.y = bounds.origin.y
        
        //DrawKnob
        CGContextSetRGBFillColor(context, 255/255, 0/255, 0/255, 0.5)
        CGContextFillEllipseInRect(context, _buttonRect)
        
        //Draw All
        CGContextFillPath(context)
    }
    
}

