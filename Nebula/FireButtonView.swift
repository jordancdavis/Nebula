//
//  FireButtonView.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//


import UIKit

class FireButtonView: UIView {
    private var _fireButton: FireButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //create Firebutton and add as subview
        _fireButton = FireButton()
        _fireButton?.backgroundColor = UIColor.clearColor()
        addSubview(_fireButton!)
        
    }
    
    //positions the knobs on the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //positioning
        var availableSpace: CGRect = bounds
        (_fireButton.frame, availableSpace ) = availableSpace.divide(availableSpace.height * 1, fromEdge: .MinYEdge)
        
    }
    
    
    //returns the Firebutton
    var fireButton: FireButton {return _fireButton!}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
