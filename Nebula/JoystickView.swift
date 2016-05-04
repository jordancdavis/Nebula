//
//  KnobColorChooserView.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class JoystickView: UIView {
    private var _joystick: Joystick!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //create joystick and add as subview
        _joystick = Joystick()
        _joystick?.backgroundColor = UIColor.clearColor()
        addSubview(_joystick!)
        
    }
    
    //positions the knobs on the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //positioning
        var availableSpace: CGRect = bounds
        (_joystick.frame, availableSpace ) = availableSpace.divide(availableSpace.height * 1, fromEdge: .MinYEdge)
        
    }
    
    
    //returns the joystick
    var joystick: Joystick {return _joystick!}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
