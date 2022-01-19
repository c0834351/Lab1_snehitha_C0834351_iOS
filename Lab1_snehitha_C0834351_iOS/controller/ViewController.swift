//
//  ViewController.swift
//  Lab1_snehitha_C0834351_iOS
//
//  Created by Sai Snehitha Bhatta on 18/01/22.
//

import UIKit

class ViewController: UIViewController {

    var player = 1
    var states = WinningPositions()
    var gameActive = true
    var positions = WinningPositions()
    
    
    
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var crossesLb: UILabel!
    @IBOutlet weak var noughtsLb: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        //not to show title in the beginning and values of players
        winner.isHidden=true
        noughtsLb.text = "0"
        crossesLb.text = "0"
        
    }

    //play again or reset the game if u swipe left/right/up/down
    @objc func swiped(gesture: UISwipeGestureRecognizer){
        let swipeGesture = gesture as UISwipeGestureRecognizer
        switch swipeGesture.direction{
        case .left, .right, .up, .down:
            print("gesture recognised")
            states.gameStates = [0,0,0,0,0,0,0,0,0]
            gameActive = true
            for i in 1..<10 {
                if let buttons = view.viewWithTag(i) as? UIButton {
                    buttons.setImage(nil, for: [])
                    buttons.alpha = 1
                    buttons.isEnabled=true
                }
            }
            noughtsLb.text = "0"
            crossesLb.text = "0"
            winner.isHidden = true
            
        default:
            break
        }
        
    }
    
    @IBAction func buttonsPressed(_ sender: UIButton) {
        let activePosition = sender.tag-1
        if states.gameStates[activePosition] == 0 && gameActive{
            states.gameStates[activePosition] = player
        addToGame(sender)
        }
    }
    // logic for displaying the cross and noughts
    func addToGame(_ sender: UIButton){
        if(sender.image(for: .normal)==nil){
            if(player == 1){
                sender.setImage(UIImage(named: "nought.png"), for: [])
                player = 2
                sender.alpha=0.5
                sender.transform = CGAffineTransform(translationX: -200, y: 0)
                UIView.animate(withDuration: 0.5) {
                    sender.transform = CGAffineTransform.identity
                }
            }
            else{
                sender.setImage(UIImage(named: "cross.png"), for: [])
                player = 1
                sender.transform = CGAffineTransform(translationX: 0, y: -150)
                UIView.animate(withDuration: 1){
                    sender.alpha=0.5
                    sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
        }
            sender.isEnabled=false
    }
        
        //check who is the winner
        for position in positions.winningPositions {
            if states.gameStates[position[0]] != 0 && states.gameStates[position[0]] == states.gameStates[position[1]] && states.gameStates[position[1]] == states.gameStates[position[2]]  {
                gameActive=false
                if states.gameStates[position[0]] == 1{
                    winner.isHidden=false
                    winner.text = "Player 1 (Noughts) is winner"
                    noughtsLb.text = "1"
                }
                else{
                    winner.isHidden=false
                    winner.text = "Player 2 (Crosses) is winner"
                    crossesLb.text = "1"
                }
            }
        }
        if drawMatch() && gameActive {
            winner.isHidden = false
            winner.text = "No Winner"
        }
    }
    
    
    
    
    // if its a tie match (no one wins)
    func drawMatch() -> Bool {
        for state in states.gameStates {
            if state == 0 {
                return false
            }
        }
        return true }
    }

