//
//  ResultsViewController.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 15.11.2020.
//

import UIKit


class ResultsViewController: UITableViewController {
    var results: [GameSession] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        results = Game.game.gameSessions
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Score", for: indexPath) as! ResultTableViewCell
        cell.dataLbl.text = results[indexPath.row].data
        cell.scoreLbl.text = results[indexPath.row].score
        return cell
    }
    
    
}
