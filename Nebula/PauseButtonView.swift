//
//  PauseButtonView.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//


import UIKit

class PauseButtonView: UIView {
    private var _pauseButton: PauseButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //create Firebutton and add as subview
        _pauseButton = PauseButton()
        _pauseButton?.backgroundColor = UIColor.clearColor()
        addSubview(_pauseButton!)
        
    }
    
    //positions the knobs on the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //positioning
        var availableSpace: CGRect = bounds
        (_pauseButton.frame, availableSpace ) = availableSpace.divide(availableSpace.height * 1, fromEdge: .MinYEdge)
        
    }
    
    
    //returns the Firebutton
    var pauseButton: PauseButton {return _pauseButton!}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
