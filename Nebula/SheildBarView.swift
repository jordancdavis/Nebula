//
//  SheildBarViewController.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class SheildBarView: UIView {
    private var _sheildBar: SheildBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //create Firebutton and add as subview
        _sheildBar = SheildBar()
        _sheildBar?.backgroundColor = UIColor.clearColor()
        addSubview(_sheildBar!)
        
    }
    
    //positions the knobs on the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //positioning
        var availableSpace: CGRect = bounds
        (_sheildBar.frame, availableSpace ) = availableSpace.divide(availableSpace.height * 1, fromEdge: .MinYEdge)
        
    }
    
    
    //returns the Firebutton
    var sheildBar: SheildBar {return _sheildBar!}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
