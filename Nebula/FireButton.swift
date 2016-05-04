//
//  FireButton.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class FireButton: UIControl {
    
    private var _buttonRect: CGRect = CGRectZero
    private var _nibRect: CGRect = CGRectZero
    var _held: Bool = false
    
    
    
    //Register Touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        _held = true
        sendActionsForControlEvents(UIControlEvents.AllTouchEvents)
    }
    
    
    //Register Move
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _held = true
        sendActionsForControlEvents(UIControlEvents.AllTouchEvents)
    }
    
    
    //Register End
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        _held = false
        sendActionsForControlEvents(UIControlEvents.AllTouchEvents)
    }
    
    
    
    //Draws The Firebutton
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        self.backgroundColor = UIColor.clearColor()
        
        //Firebutton size/location
        _buttonRect = CGRectZero
        _buttonRect.size.width = bounds.width
        _buttonRect.size.height = bounds.height
        _buttonRect.origin.x = bounds.origin.x
        _buttonRect.origin.y = bounds.origin.y
        
        //DrawKnob
        CGContextSetRGBFillColor(context, 150/255, 150/255, 150/255, 0.25)
        CGContextFillEllipseInRect(context, _buttonRect)
        
        
        //NIB size/location
        _nibRect = CGRectZero
        _nibRect.size.width = _buttonRect.width * 0.4
        _nibRect.size.height = _nibRect.width
        
        //position nib
        _nibRect.origin.x =  _buttonRect.midX -  _nibRect.width * 0.5
        _nibRect.origin.y =  _buttonRect.midY - _nibRect.height * 0.5
        
        //DrawNib
        CGContextSetRGBFillColor(context, 30/255, 144/255, 255/255, 0.5)
        CGContextFillEllipseInRect(context, _nibRect)
        
        //Draw All
        CGContextFillPath(context)
    }
    
}
