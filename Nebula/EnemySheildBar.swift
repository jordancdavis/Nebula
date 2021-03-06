//
//  EnemySheildBar.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class EnemySheildBar: UIView {
    
    private var _outlineRect: CGRect = CGRectZero
    private var _sheildRect: CGRect = CGRectZero
    private var _value: Int = 300
    private var _rColor: CGFloat = 0
    private var _gColor: CGFloat = 1
    private var _bColor: CGFloat = 0
    private var _aColor: CGFloat = 0.5

    
    //Draws The PauseButton
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        self.backgroundColor = UIColor.clearColor()
        
        //Joystick size/location
        _outlineRect = CGRectZero
        _outlineRect.size.width = bounds.width
        _outlineRect.size.height = bounds.height
        _outlineRect.origin.x = bounds.origin.x
        _outlineRect.origin.y = bounds.origin.y
        
        
        //DrawKnob
        CGContextSetFillColorWithColor(context, UIColor(red: 1, green: 1, blue: 1, alpha: aColor).CGColor)
        CGContextFillRect(context, _outlineRect)
        
        
        //NIB size/location
        _sheildRect = CGRectZero
        _sheildRect.size.width = (_outlineRect.width * 0.8)
        _sheildRect.size.height = (_outlineRect.height * 0.95) * (CGFloat(value) / 300)
        _sheildRect.origin.x = _outlineRect.origin.x + (_outlineRect.width * 0.1)
        _sheildRect.origin.y = _outlineRect.origin.y - (_outlineRect.height * 0.025) + (_outlineRect.height - _sheildRect.height)
        
        //DrawNib
        CGContextSetFillColorWithColor(context, UIColor(red: rColor, green: gColor, blue: bColor, alpha: aColor).CGColor)
        CGContextFillRect(context, _sheildRect)
        
        
        //Draw All
        CGContextFillPath(context)
    }
    
    var value: Int {
        get{return _value}
        set{
            _value = newValue
            setNeedsDisplay()
        }
    }
    
    var rColor: CGFloat {
        get {return _rColor}
        set { _rColor = newValue
            setNeedsDisplay()
        }
    }
    
    var gColor: CGFloat {
        get {return _gColor}
        set { _gColor = newValue
            setNeedsDisplay()
        }
    }
    
    var bColor: CGFloat {
        get {return _bColor}
        set { _bColor = newValue
            setNeedsDisplay()
        }
    }
    
    var aColor: CGFloat {
        get {return _aColor}
        set { _aColor = newValue
            setNeedsDisplay()
        }
    }
}


