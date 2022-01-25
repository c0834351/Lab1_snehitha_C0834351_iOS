//
//  ViewController.swift
//  Lab1_snehitha_C0834351_iOS
//
//  Created by Sai Snehitha Bhatta on 18/01/22.
//

import UIKit
import CoreData


var tictac: [NSManagedObject] = []
var player2: [NSManagedObject] = []
var undo = UndoManager()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class ViewController: UIViewController {

    var player = 1
    var states = WinningPositions()
    var gameActive = true
    var positions = WinningPositions()
    var n1=0
    var c1=0
    var saveN: [Int] = []
    var btn: UIButton!
    var d1:String = "0"
    var d2:String = "0"
    
    
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var crossesLb: UILabel!
    @IBOutlet weak var noughtsLb: UILabel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        becomeFirstResponder()
        
        noughtsLb.text = d1
        crossesLb.text = d2
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
//        noughtsLb.text = "0"
//        crossesLb.text = "0"
        
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
            //  noughtsLb.text = "0"
            //  crossesLb.text = "0"
            winner.isHidden = true
            
        default:
            break
        }
        
    }
    ///////////
    
    
    @IBAction func buttonsPressed(_ sender: UIButton) {
        btn = sender
        let activePosition = sender.tag-1
        print("\(sender.tag)@@@@@@@@@@@@@@@@@")
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName:"Tictactoe", in:context)!
//        let record = NSManagedObject(entity:entity, insertInto:context)
//        record.setValue(String(sender.tag), forKey:"gameState")
//        saveData()
        
        if states.gameStates[activePosition] == 0 && gameActive{
            states.gameStates[activePosition] = player
        addToGame(sender)
            
        }
    }
    // logic for displaying the cross and noughts
    func addToGame(_ sender: UIButton){
        if(sender.image(for: .normal)==nil){
            if(player == 1){
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                    return
                }
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName:"Tictactoe", in:context)!
                let record = NSManagedObject(entity:entity, insertInto:context)
                record.setValue(String(sender.tag), forKey:"gameState")
                saveData()
                sender.setImage(UIImage(named: "nought.png"), for: [])
                player = 2
                
                sender.alpha=0.5
                sender.transform = CGAffineTransform(translationX: -200, y: 0)
                UIView.animate(withDuration: 0.5) {
                    sender.transform = CGAffineTransform.identity
                }
            }
            else{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                    return
                }
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName:"Player2", in:context)!
                let record = NSManagedObject(entity:entity, insertInto:context)
                record.setValue(String(sender.tag), forKey:"gameState")
                saveData()
                
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
                    print("\(tictac.count) -------" )
                    ///
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName:"Tictactoe", in:context)!
                    let record = NSManagedObject(entity:entity, insertInto:context)
                    n1 += 1
                    record.setValue(String(n1), forKey:"score")
                    
                    //let c = tictac[tictac.count-1]
//                    let s = (String(describing: c.value(forKey: "score"))
//                    n1 = n1 + Int(s)
                  //  n1 = Int(String(describing: c.value(forKey: "score") as! NSString).integerValue
                    saveData()
                    fetchData1()
                    print("\(tictac.count) -------" )
                    let sc = tictac[tictac.count-1]
                    noughtsLb.text = String(describing: sc.value(forKey: "score") ?? "0")
                    d1 = String(describing: sc.value(forKey: "score") ?? "0")
                    print(String(describing: sc.value(forKey: "score")))
                    
                    //noughtsLb.text = String(n1)
                }
                else{
                    winner.isHidden=false
                    winner.text = "Player 2 (Crosses) is winner"
                    c1 += 1
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName:"Player2", in:context)!
                    let record = NSManagedObject(entity:entity, insertInto:context)
                    record.setValue(String(c1), forKey:"score")
                    saveData()
                    fetchData2()
                    let sc = player2[player2.count-1]
                    crossesLb.text = String(describing: sc.value(forKey: "score") ?? "0")
                    d2 = String(describing: sc.value(forKey: "score") ?? "0")
                    
                    ///
                   // crossesLb.text = String(c1)
                }
            }
        }
        if drawMatch() && gameActive {
            winner.isHidden = false
            winner.text = "No Winner"
        }
    }
    
    //fetching data
    func fetchData1(){
      //  let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Tictactoe")
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Tictactoe")
        do {
           tictac =
            try context.fetch(fetchRequest)
        } catch
        let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
}
    
    func fetchData2(){
      //  let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Tictactoe")
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Player2")
        do {
           player2 =
            try context.fetch(fetchRequest)
        } catch
        let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
}
    
    
    //
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving the folder \(error.localizedDescription)")
        }
    }
    
    //shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake{
            print("phone shake")
            positions.gameStates = saveN
            print("\(positions.gameStates) \(btn.tag) ")
            if player == 1{
                player = 2
            }
            else
            {
                player=1
            }
            btn.setImage(nil, for: .normal)
            
        }
        
        //delete
        do{
       // self.context.delete(self.details[indexPath.row])
            try context.save()
        }catch{
            print(error)
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

