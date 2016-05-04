//
//  Knob.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class Joystick: UIControl {
    
    private var _joystickRect: CGRect = CGRectZero
    private var _nibRect: CGRect = CGRectZero
    private var _xValue: CGFloat = 0
    private var _yValue: CGFloat = 0
    private var _angle: CGFloat = 3.14159 /  (-2)
    private var _centerX: CGFloat = 57
    private var _centerY: CGFloat = 23.5
    private var _radius: CGFloat = 0.0
    var _held: Bool = false


    
    //Register Touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let touch: UITouch = touches.first!
        let touchPoint: CGPoint = touch.locationInView(self)
        _held = true
        
        //moves the nib
        setNibPositionToTouch(touchPoint.x, touchPointY: touchPoint.y)
        sendActionsForControlEvents(UIControlEvents.AllTouchEvents)
    }
    
    
    //Register Move
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchPoint: CGPoint = touch.locationInView(self)
        _held = true

        //moves the nib
        setNibPositionToTouch(touchPoint.x, touchPointY: touchPoint.y)
        sendActionsForControlEvents(UIControlEvents.AllTouchEvents)
    }
    
    
    //Register End
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        _held = false
        
        //moves the nib
        setNibPositionToTouch(59.0, touchPointY: 114.5)
        sendActionsForControlEvents(UIControlEvents.AllTouchEvents)
    }
    
    
    
    //Draws The Joystick and Nib
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        self.backgroundColor = UIColor.clearColor()
        
        //Joystick size/location
        _joystickRect = CGRectZero
        _joystickRect.size.width = bounds.width
        _joystickRect.size.height = bounds.height
        _joystickRect.origin.x = bounds.origin.x
        _joystickRect.origin.y = bounds.origin.y
    
        //DrawKnob
        CGContextSetRGBFillColor(context, 150/255, 150/255, 150/255, 0.25)
        CGContextFillEllipseInRect(context, _joystickRect)
        
        
        //NIB size/location
        _nibRect = CGRectZero
        _nibRect.size.width = _joystickRect.width * 0.4
        _nibRect.size.height = _nibRect.width
        

        
        _radius = _joystickRect.width * 0.3
        _centerX = _joystickRect.midX + _radius * CGFloat(cos(_angle))
        _centerY = _joystickRect.midY + _radius * CGFloat(sin(_angle))
        //position nib
        _nibRect.origin.x = _centerX -  _nibRect.width * 0.5
        _nibRect.origin.y = _centerY - _nibRect.height * 0.5
        
        //DrawNib
        CGContextSetRGBFillColor(context, 0/255, 0/255, 0/255, 0.50)
        CGContextFillEllipseInRect(context, _nibRect)
        
        //Draw All
        CGContextFillPath(context)
    }
    
    
    
    //adjust the nibs to that it represents the selected touch direction
    func setNibPositionToTouch(touchPointX:CGFloat, touchPointY:CGFloat){
        touchAngle = atan2(touchPointY - _joystickRect.midY , touchPointX - _joystickRect.midX)
    }
    
    var touchAngle: CGFloat {
        get{return _angle}
        set{
            _angle = newValue
            setNeedsDisplay()
        }
    }
}




