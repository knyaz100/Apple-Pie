//
//  ViewController.swift
//  Apple Pie
//
//  Created by Vasily Churbanov on 2021-02-18.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordMeaningLabel: UILabel!
    

    
    // MARK: - Properties
    var currentGame: Game!
    let incorrectMovesAllowed = 7
    var listOfWords = [
        "СКРУПУЛЁЗНЫЙ" ,
        "ПОЧЕТНИК" ,
        "БАСУРМАН" ,
        "АББЕРАЦИЯ" ,
        "ПЕРДИМОНОКЛЬ" ,
        "ТРАНСЦЕНДЕНТНЫЙ" ,
        "ОСТРАКИЗМ" ,
        "ПАРИТЕТ" ,
        "АПРОБИРОВАТЬ" ,
        "КЛЕВРЕТ" ,
        "ДЕСТРУКТИВНЫЙ" ,
        "АННЕКСИЯ" ,
        "МАТРИМОНИАЛЬНЫЙ" ,
        "КАЙМАН" ,
        "ПРОФОРМА" ,
        "АПОЛОГЕТ" ,
        "ЭКЗАЛЬТРОВАННЫЙ" ,
        "СИНОПСИС" ,
        "ДИФФАМАЦИЯ"
    ]
    
    var listOfMeanings = [
        "Дотошный" ,
        "Поклонник" ,
        "Иноземец и иновер" ,
        "Отклонений" ,
        "Нечто удивляющее" ,
        "Непозноваемый" ,
        "Изгнание" ,
        "Равенство" ,
        "Официально утвердить" ,
        "Приспешник" ,
        "Разрушительный" ,
        "Насильственное присоединение" ,
        "Брачный" ,
        "Крокодил" ,
        "Формальность" ,
        "Сторонник" ,
        "Восторженный" ,
        "Обозрение" ,
        "Клевета" ,
    ]
    
    
    var wordMeaningsDic: Dictionary <String, String> = [:]
    var isRoundInProgress = false
    
    var totalWins = 0 {
        didSet {
            isRoundInProgress = false
            updateUIRoundEnd(win: true)
        }
    }
    var totalLosses = 0 {
        didSet {
            isRoundInProgress = false
            updateUIRoundEnd(win: false)
        }
    }
    
    //MARK: - Methods
    
    func enableButtons() {
        for button in letterButtons {
            button.isEnabled = true
        }
    }
    
    func disableButtons() {
        for button in letterButtons {
            button.isEnabled = false
        }
    }
    
    func newRound() {

        if !listOfWords.isEmpty {
            listOfWords = listOfWords.shuffled()
            let newWord = listOfWords.removeFirst()
            currentGame =  Game (word: newWord, incorrectMovesRemaining: incorrectMovesAllowed)
            isRoundInProgress = true
            enableButtons()
            updateUI()
        } else {
            isRoundInProgress = false
            disableButtons()
            updateUITotalWin()
        }

      
    }
    
    func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
        let imageNumber = movesRemaining < 0 ? 0 : movesRemaining < 8 ? movesRemaining : 7
        let imageName = "Tree \(imageNumber)"
        treeImageView.image = UIImage(named: imageName)
        updateCorrectWordLabel()
        scoreLabel.text = "Выигрыши: \(totalWins)  Проигрыши: \(totalLosses)"
        wordMeaningLabel.text = ""
        
        
    }
    
    func updateUITotalWin() {
        let imageNumber = 7
        let imageName = "Tree \(imageNumber)"
        treeImageView.image = UIImage(named: imageName)
        if(totalWins > totalLosses) {
            correctWordLabel.textColor = .systemRed
            correctWordLabel.text = "П О Л Н А Я  П О Б Е Д А!"
        } else {
            correctWordLabel.textColor = .systemPurple
            correctWordLabel.text = "век живи - век учись!"
        }
        
        wordMeaningLabel.text = ""
        scoreLabel.text = "Выигрыши: \(totalWins)  Проигрыши: \(totalLosses)"
    
    }
    
    func updateUIRoundEnd(win: Bool) {
        //let imageNumber = 7
        //let imageName = "Tree \(imageNumber)"
        //treeImageView.image = UIImage(named: imageName)
        if (win) {
            correctWordLabel.textColor = .systemGreen
        } else {
            correctWordLabel.textColor = .systemRed
        }
        correctWordLabel.text = currentGame.word
        scoreLabel.text = "Выигрыши: \(totalWins)  Проигрыши: \(totalLosses)"
        wordMeaningLabel.textColor = .systemGray
        wordMeaningLabel.text = wordMeaningsDic[currentGame.word]?.lowercased()
    }
    
    func updateCorrectWordLabel() {
        var displayWord = [String]()
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.textColor = .none
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    
    func updateState() {
        
        if currentGame.incorrectMovesRemaining < 1 {
            totalLosses += 1
        } else if currentGame.guessedWord == currentGame.word {
            totalWins += 1
        } else {
                updateUI()
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add a tap gesture recognizer
        
        let correctWordLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleEndRoundTap(_:)))
        let treeImageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleEndRoundTap(_:)))
        correctWordLabel.isUserInteractionEnabled = true
        correctWordLabel.addGestureRecognizer(correctWordLabelTapRecognizer)
        treeImageView.isUserInteractionEnabled = true
        treeImageView.addGestureRecognizer(treeImageTapRecognizer)
        let seq = zip(listOfWords, listOfMeanings)
        wordMeaningsDic = Dictionary(uniqueKeysWithValues: seq)
        newRound()
    }
    
    //  MARK: IB Actions
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = sender.title(for: .normal)!
        currentGame.playerGuessed(letter: Character(letter))
        updateState()
    }
    
    @objc
    func handleEndRoundTap(_ gestureRecognize: UIGestureRecognizer) {
        
        //print(#line, "TAP")
        
        if(!isRoundInProgress) {
            newRound()
        }
    
    }
    
    
}

