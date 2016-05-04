//
//  LeaderboardView.swift
//  Nebula
//
//  Created by Jordan Davis on 4/28/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//view used to gather player name and sets up a new game
class LeaderboardView: UIView {
    private var _game: Game = Game.sharedInstance
    
    private var _first: UILabel = UILabel()
    private var _second: UILabel = UILabel()
    private var _third: UILabel = UILabel()
    private var _forth: UILabel = UILabel()
    private var _fifth: UILabel = UILabel()
    
     var _firstUsername: UILabel = UILabel()
     var _secondUsername: UILabel = UILabel()
     var _thirdUsername: UILabel = UILabel()
     var _forthUsername: UILabel = UILabel()
     var _fifthUsername: UILabel = UILabel()
    
     var _firstScore: UILabel = UILabel()
     var _secondScore: UILabel = UILabel()
     var _thirdScore: UILabel = UILabel()
     var _forthScore: UILabel = UILabel()
     var _fifthScore: UILabel = UILabel()
    

    private var _returnToMenuButton: UIButton = UIButton()
    private var _backScreen: UIButton = UIButton()

    
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
        
        _backScreen.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        addSubview(_backScreen)
        
        //online button
        _returnToMenuButton.setTitle("Menu", forState: UIControlState.Normal)
        _returnToMenuButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        _returnToMenuButton.layer.borderColor = UIColor.whiteColor().CGColor
        _returnToMenuButton.layer.borderWidth = 2.0
        _returnToMenuButton.layer.cornerRadius = 10
        _returnToMenuButton.showsTouchWhenHighlighted = true
        addSubview(_returnToMenuButton)

        _first.text = "1."
        _first.textColor = UIColor.greenColor()
        _second.text = "2."
        _second.textColor = UIColor.greenColor()
        _third.text = "3."
        _third.textColor = UIColor.greenColor()
        _forth.text = "4."
        _forth.textColor = UIColor.greenColor()
        _fifth.text = "5."
        _fifth.textColor = UIColor.greenColor()
        addSubview(_fifth)
        addSubview(_forth)
        addSubview(_third)
        addSubview(_second)
        addSubview(_first)
        
        _firstScore.text = String(_game._highScores[0])
        _secondScore.text = String(_game._highScores[1])
        _thirdScore.text = String(_game._highScores[2])
        _forthScore.text = String(_game._highScores[3])
        _fifthScore.text = String(_game._highScores[4])
        _firstUsername.text = String(_game._highScoresNames[0])
        _secondUsername.text = String(_game._highScoresNames[1])
        _thirdUsername.text = String(_game._highScoresNames[2])
        _forthUsername.text = String(_game._highScoresNames[3])
        _fifthUsername.text = String(_game._highScoresNames[4])
        
        _firstUsername.textColor = UIColor.greenColor()
        _secondUsername.textColor = UIColor.greenColor()
        _thirdUsername.textColor = UIColor.greenColor()
        _forthUsername.textColor = UIColor.greenColor()
        _fifthUsername.textColor = UIColor.greenColor()
        _firstScore.textColor = UIColor.greenColor()
        _secondScore.textColor = UIColor.greenColor()
        _thirdScore.textColor = UIColor.greenColor()
        _forthScore.textColor = UIColor.greenColor()
        _fifthScore.textColor = UIColor.greenColor()
        
        addSubview(_fifthUsername)
        addSubview(_forthUsername)
        addSubview(_thirdUsername)
        addSubview(_secondUsername)
        addSubview(_firstUsername)
        addSubview(_fifthScore)
        addSubview(_forthScore)
        addSubview(_thirdScore)
        addSubview(_secondScore)
        addSubview(_firstScore)
    }
    
    func updateBoard(){
        _firstScore.text = String(_game._highScores[0])
        _secondScore.text = String(_game._highScores[1])
        _thirdScore.text = String(_game._highScores[2])
        _forthScore.text = String(_game._highScores[3])
        _fifthScore.text = String(_game._highScores[4])
        
        _firstUsername.text = String(_game._highScoresNames[0])
        _secondUsername.text = String(_game._highScoresNames[1])
        _thirdUsername.text = String(_game._highScoresNames[2])
        _forthUsername.text = String(_game._highScoresNames[3])
        _fifthUsername.text = String(_game._highScoresNames[4])
        setNeedsDisplay()
    }
    
    //keep game looking good for all orientations
    override func layoutSubviews() {
        _first.frame = CGRectMake(self.bounds.width * 0.1 , (self.bounds.height / 3 )+15, 200, 60)
        _second.frame = CGRectMake(self.bounds.width * 0.1 , (self.bounds.height / 3)+55, 200, 60)
        _third.frame = CGRectMake(self.bounds.width * 0.1 , (self.bounds.height / 3 )+100, 200, 60)
        _forth.frame = CGRectMake(self.bounds.width * 0.1 , (self.bounds.height / 3)+145, 200, 60)
        _fifth.frame = CGRectMake(self.bounds.width * 0.1 , (self.bounds.height / 3)+190, 200, 60)
        
        _firstUsername.frame = CGRectMake(self.bounds.width * 0.3, (self.bounds.height / 3 )+15, 200, 60)
        _secondUsername.frame = CGRectMake(self.bounds.width * 0.3, (self.bounds.height / 3)+55, 200, 60)
        _thirdUsername.frame = CGRectMake(self.bounds.width * 0.3, (self.bounds.height / 3 )+100, 200, 60)
        _forthUsername.frame = CGRectMake(self.bounds.width * 0.3, (self.bounds.height / 3)+145, 200, 60)
        _fifthUsername.frame = CGRectMake(self.bounds.width * 0.3, (self.bounds.height / 3)+190, 200, 60)
        
        _firstScore.frame = CGRectMake(self.bounds.width / 1.5 + 25, (self.bounds.height / 3 )+15, 200, 60)
        _secondScore.frame = CGRectMake(self.bounds.width / 1.5 + 25, (self.bounds.height / 3)+55, 200, 60)
        _thirdScore.frame = CGRectMake(self.bounds.width / 1.5 + 25, (self.bounds.height / 3 )+100, 200, 60)
        _forthScore.frame = CGRectMake(self.bounds.width / 1.5 + 25, (self.bounds.height / 3)+145, 200, 60)
        _fifthScore.frame = CGRectMake(self.bounds.width / 1.5 + 25, (self.bounds.height / 3)+190, 200, 60)
        
        _returnToMenuButton.frame = CGRectMake(self.bounds.width / 2 - 75, (self.bounds.height / 2 ) + 180, 150, 50)
        _backScreen.frame = CGRectMake(0,(self.bounds.height / 3) + 15 ,UIScreen.mainScreen().bounds.size.width, 235)

    }
    
    var returnToMenu: UIButton {
        return _returnToMenuButton
    }
    

}
