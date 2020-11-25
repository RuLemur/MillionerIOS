//
//  GameViewController.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 09.11.2020.
//

import UIKit


protocol GameViewDelegate: AnyObject {
    func gameWasOver(_ data: String,_ score: String)
}


class GameViewController: UIViewController {
    
    weak var gameViewDelegate: GameViewDelegate?
    
    var questions: [Question] = []
    var currentQuestion: Question!
    var questionNumber: Int = 1
    var rightQuestionNumber: Int = 1
    let prices = ["0","500","1 000","2 000","3 000","5 000","10 000", "15 000", "25 000", "50 000", "100 000", "200 000", "400 000", "800 000", "1 500 000", "3 000 000"]
    
    @IBOutlet weak var quizStack: UIStackView!
    @IBOutlet weak var questionLbl: UITextView!
    @IBOutlet weak var varA: UIButton!
    @IBOutlet weak var varB: UIButton!
    @IBOutlet weak var varC: UIButton!
    @IBOutlet weak var varD: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnArray = [
            varA,varB,varC,varD
        ]
        
        for btn in btnArray {
            btn!.titleLabel!.adjustsFontSizeToFitWidth = true
            btn!.titleLabel!.minimumScaleFactor = 0.5
            btn!.layer.cornerRadius =  btn!.frame.size.height/2
        }
        scoreLbl.adjustsFontSizeToFitWidth = true
        showNewQuestion()
        
    }
    
    func showNewQuestion(){
        getNextQuestion()
        let question = currentQuestion!
        
        questionLbl.text = question.question
        rightQuestionNumber = Int.random(in: 0...3)
        print(rightQuestionNumber + 1)
        scoreLbl.text = "Вопрос на " + prices[questionNumber] + " шекелей"
        var answers = question.wrongAnswers
        answers.shuffle()
        answers.insert(question.answer, at: rightQuestionNumber)
        
        headerLbl.text = "Вопрос " + String(questionNumber)
        (quizStack.arrangedSubviews[0] as! UIButton).setTitle( answers[0], for: .normal)
        (quizStack.arrangedSubviews[1] as! UIButton).setTitle( answers[1], for: .normal)
        (quizStack.arrangedSubviews[2] as! UIButton).setTitle( answers[2], for: .normal)
        (quizStack.arrangedSubviews[3] as! UIButton).setTitle( answers[3], for: .normal)
    }
    
    @IBAction func chooseAnswer(_ sender: UIButton) {
        let userAnswer = checkRightAnswer(sender.titleLabel!.text!)
        answerWasChoosen(sender, userAnswer)
    }
    
    func answerWasChoosen(_ btn: UIButton, _ isRight: Bool){
        let startColor = btn.backgroundColor
        if isRight{
            if questionNumber == 15 {
                let alert = UIAlertController(title: "You win!!!", message: "You win!!!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm E, d MMM y"
                    
                    self.gameViewDelegate?.gameWasOver(formatter.string(from: Date()), self.prices[self.questionNumber])
                    NSLog("User pressed OK!!")
                }))
                
                self.present(alert, animated: true)
            } else {
                
                UIView.animate(withDuration: 0.4, animations: {
                    
                    btn.backgroundColor = .systemGreen
                    self.questionNumber += 1
                }){ (true) in
                    btn.backgroundColor = startColor
                    self.showNewQuestion()
                    
                    
                }
            }
        }
        else {
            UIView.animate(withDuration: 0.4, animations: {
                btn.backgroundColor = .red
                
                UIView.animate(withDuration: 0.3 ,delay: 0.1, animations: {
                    (self.quizStack.arrangedSubviews[self.rightQuestionNumber] as! UIButton).backgroundColor = .systemGreen
                }) { (true) in
                    btn.backgroundColor = startColor
                    
                    (self.quizStack.arrangedSubviews[self.rightQuestionNumber] as! UIButton).backgroundColor = startColor
                    let alert = UIAlertController(title: "You loose!!!", message: "Вы заработали: " + self.prices[self.questionNumber-1] + " шекелей", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay:(", style: .default, handler: { (action:UIAlertAction!) -> Void in
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm E, d MMM y"
                        self.gameViewDelegate?.gameWasOver(formatter.string(from: Date()), self.prices[self.questionNumber-1])
                        self.dismiss(animated: true, completion: nil)
                        
                        
                    }))
                    self.present(alert, animated: true)
                    
                }
            })
            
        }
        
    }
    
    func getAllQuestions(){
        let data = QuizParser().readLocalFile("quiz_questions")
        questions = data!.data
    }
    
    func getNextQuestion(){
        if questions.isEmpty {
            getAllQuestions()
        }
        var getterQuestions: NextQuestionStrategy
        
        if Game.game.getGameSettings().isRandomly {
            getterQuestions = NewRandomQuestion()
        } else {
            getterQuestions = NextQuestion()
        }
        
        currentQuestion = getterQuestions.nextQuestion(questions: questions, lastQuestionNumber: questionNumber)
        
    }
    
    func checkRightAnswer(_ answer: String) -> Bool{
        return answer == currentQuestion.answer
    }
    
}

class NewRandomQuestion: NextQuestionStrategy {
    func nextQuestion(questions: [Question], lastQuestionNumber: Int) -> Question? {
        return questions.randomElement()
    }
    
    
}

class NextQuestion: NextQuestionStrategy {
    func nextQuestion(questions: [Question], lastQuestionNumber: Int) -> Question? {
        return questions[lastQuestionNumber-1]
    }
    
    
}
