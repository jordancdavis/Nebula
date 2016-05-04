//
//  LeaderboardController.swift
//  Nebula
//
//  Created by Jordan Davis on 4/28/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit


class LeaderboardController: UIViewController {
    private var _game: Game = Game.sharedInstance
    private var _highScoreMessage:UIAlertController?
    var text = UITextField()
    
    var leaderboard: LeaderboardView {
        return view as! LeaderboardView
    }
    
    override func loadView() {
        view = LeaderboardView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //setup buttons
        leaderboard.returnToMenu.addTarget(self, action: #selector(LeaderboardController.returnToMenu), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        //record username action
        let action: UIAlertAction = UIAlertAction(title: "Enter", style: .Default) { action -> Void in
            self.text = (self._highScoreMessage!.textFields?.first)!
            self._game.addNewName(self.text.text!)
            self.leaderboard.updateBoard()
            self._game.reset()
        }

        //disable resume button
        if(_game._gameOver){
            if(_game._ranking >= 1 && _game._ranking <= 5){
                _highScoreMessage = UIAlertController(title: "New High Score", message: "Enter your name", preferredStyle: UIAlertControllerStyle.Alert)
                _highScoreMessage!.addAction(action)
                _highScoreMessage!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "gamertag"
                    textField.textColor = UIColor.blueColor()
                })
                self.presentViewController(_highScoreMessage!, animated: true, completion: nil)
        
            }
        }
    }
    
    func returnToMenu() {
        navigationController?.popViewControllerAnimated(false)
    }
        
}

