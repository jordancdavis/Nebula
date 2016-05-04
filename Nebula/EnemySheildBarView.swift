//
//  EnemySheildBarView.swift
//  Nebula
//
//  Created by Jordan Davis on 4/30/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class EnemySheildBarView: UIView {
    private var _eneemySheildBar: EnemySheildBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //create Firebutton and add as subview
        _eneemySheildBar = EnemySheildBar()
        _eneemySheildBar?.backgroundColor = UIColor.clearColor()
        addSubview(_eneemySheildBar!)
        
    }
    
    //positions the knobs on the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //positioning
        var availableSpace: CGRect = bounds
        (_eneemySheildBar.frame, availableSpace ) = availableSpace.divide(availableSpace.height * 1, fromEdge: .MinYEdge)
        
    }
    
    
    //returns the Firebutton
    var sheildBar: EnemySheildBar {return _eneemySheildBar!}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
