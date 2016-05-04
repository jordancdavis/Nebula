//
//  MainMenuViewController.swift
//  Nebula
//
//  Created by Jordan Davis on 4/27/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//view used to gather player name and sets up a new game
class MainMenuView: UIView {
    
    private var _resumeGameButton: UIButton = UIButton()
    private var _startGameButton: UIButton = UIButton()
    private var _leaderboardButton: UIButton = UIButton()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //allow user to touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let background = UIImageView(frame: CGRectMake(0,0,width,height))
        background.image = UIImage(named: "space4.png")
        background.contentMode = UIViewContentMode.ScaleAspectFill
        addSubview(background)
        sendSubviewToBack(background)
        
        
        let logo = CGRectMake(0,75,UIScreen.mainScreen().bounds.size.width,125)
        let logoImage = UIImageView(frame: logo)
        logoImage.image = UIImage(named: "nebulaTitle.png")
        addSubview(logoImage)
        
        //online button
        _resumeGameButton.setTitle("Resume Game", forState: UIControlState.Normal)
        _resumeGameButton.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        _resumeGameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        _resumeGameButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        _resumeGameButton.layer.borderColor = UIColor.whiteColor().CGColor
        _resumeGameButton.layer.borderWidth = 2.0
        _resumeGameButton.layer.cornerRadius = 10
        _resumeGameButton.showsTouchWhenHighlighted = true
        addSubview(_resumeGameButton)
        
        //local button
        _startGameButton.setTitle("Start New Game", forState: UIControlState.Normal)
        _startGameButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        _startGameButton.layer.borderColor = UIColor.whiteColor().CGColor
        _startGameButton.layer.borderWidth = 2.0
        _startGameButton.layer.cornerRadius = 10
        _startGameButton.showsTouchWhenHighlighted = true
        addSubview(_startGameButton)
        
        //online button
        _leaderboardButton.setTitle("High Scores", forState: UIControlState.Normal)
        _leaderboardButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        _leaderboardButton.layer.borderColor = UIColor.whiteColor().CGColor
        _leaderboardButton.layer.borderWidth = 2.0
        _leaderboardButton.layer.cornerRadius = 10
        _leaderboardButton.showsTouchWhenHighlighted = true
        addSubview(_leaderboardButton)
        
    }
    
    //keep game looking good for all orientations
    override func layoutSubviews() {
            _resumeGameButton.frame = CGRectMake(self.bounds.width / 2 - 125, (self.bounds.height / 3)+30, 250, 75)
            _startGameButton.frame = CGRectMake(self.bounds.width / 2 - 125, (self.bounds.height / 2 )+30, 250, 75)
            _leaderboardButton.frame = CGRectMake(self.bounds.width / 2 - 125, (self.bounds.height / 1.5)+30, 250, 75)
    }
    
    var resumeGame: UIButton {
        return _resumeGameButton
    }
    
    var startGame: UIButton {
        return _startGameButton
    }
    
    var leaderboard: UIButton {
        return _leaderboardButton
    }
    
    func activeResumeButton(activate: Bool){
        if(activate){
            _resumeGameButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            _resumeGameButton.layer.borderColor = UIColor.whiteColor().CGColor

        } else {
            _resumeGameButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30)
            _resumeGameButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor
            
        }
        _resumeGameButton.enabled = activate
    
    }
    
}
