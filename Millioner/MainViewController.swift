//
//  ViewController.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 24.10.2020.
//

import UIKit

class MainViewController: UIViewController {
    
    let game = Game.game
    
    @IBOutlet weak var lastScore: UILabel!
    @IBOutlet weak var newGame: UIButton!
    @IBOutlet weak var results: UIButton!
    @IBOutlet weak var settings: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnArray = [
            newGame,results,settings
        ]
        
        for btn in btnArray {
            btn!.titleLabel!.adjustsFontSizeToFitWidth = true
            btn!.titleLabel!.minimumScaleFactor = 0.5
            btn!.layer.cornerRadius =  btn!.frame.size.height/2
        }

        
        if game.gameSessions.last?.score == nil {
            lastScore.text = "No results"
        } else {
            lastScore.text = "Last result: " + game.gameSessions.last!.score
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "startGame":
            guard let destionation = segue.destination as? GameViewController else {
                return
            }
            destionation.gameViewDelegate = self
            
        default:
            break
        }
    }
    
    @IBAction func startGame(_ sender: Any) {
        game.newGameSession()
        
        performSegue(withIdentifier: "startGame", sender: self)
    }
    
}

extension MainViewController: GameViewDelegate{
    func gameWasOver(_ data: String ,_ score: String) {
        game.gameSession.newResult(data, score)
        game.save()
        let text = game.gameSessions.last?.score ?? "0"
        lastScore.text = "Last result: " + text
        
        
        
    }
}
