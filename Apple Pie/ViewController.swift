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
        "Отклонение" ,
        "Нечто удивляющее" ,
        "Непознаваемый" ,
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
    var initialWordsCount = 0
    var isRoundInProgress = false
    
    var totalWins = 0 {
        didSet {
            isRoundInProgress = false
            updateUIRoundEnd(win: true)
            disableButtons()
        }
    }
    var totalLosses = 0 {
        didSet {
            isRoundInProgress = false
            updateUIRoundEnd(win: false)
            disableButtons()
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
            updateUITotalEnd()
        }
  
    }
    
    func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
        let imageNumber = movesRemaining < 0 ? 0 : movesRemaining <= incorrectMovesAllowed ? movesRemaining : incorrectMovesAllowed
        let imageName = "Tree \(imageNumber)"
        treeImageView.image = UIImage(named: imageName)
        updateCorrectWordLabel()
        updateScoreLabel()
        wordMeaningLabel.textColor = .systemGray
        wordMeaningLabel.text = wordMeaningsDic[currentGame.word]?.lowercased()
        
    }
    
    func updateUITotalEnd() {
        let imageNumber = 7
        let imageName = "Tree \(imageNumber)"
        treeImageView.image = UIImage(named: imageName)
        let percentOfWins: Int = 100*(totalWins)/initialWordsCount
        
        if( percentOfWins > 50) {
            correctWordLabel.textColor = .systemRed
            correctWordLabel.text = getDisplayWord(word: "ПОБЕДА")
        } else {
            correctWordLabel.textColor = .systemPurple
            correctWordLabel.text = "век живи - век учись!"
        }
        wordMeaningLabel.text = "угадано \(percentOfWins)% слов"
        //wordMeaningLabel.text = "игра окончена, большое спасибо!"
    }
    
    func updateUIRoundEnd(win: Bool) {
        
        if (win) {
            correctWordLabel.textColor = .systemGreen
        } else {
            correctWordLabel.textColor = .systemRed
        }
        correctWordLabel.text = getDisplayWord(word: currentGame.word)
        updateScoreLabel()
        
        wordMeaningLabel.text = wordMeaningsDic[currentGame.word]?.lowercased()
    }
    
    func updateScoreLabel() {
        scoreLabel.textColor = .systemBlue
        scoreLabel.text = "Угадано: \(totalWins)  Не угадано: \(totalLosses) Всего: \(totalWins+totalLosses) из \(initialWordsCount)"
    }
    
    func updateCorrectWordLabel() {
        var displayWord = [String]()
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.textColor = .none
        correctWordLabel.text = getDisplayWord(word: currentGame.guessedWord)
    }
    
    func getDisplayWord(word: String) -> String {
        
        var displayWord = [String]()
        for letter in word {
            displayWord.append(String(letter))
        }
        return displayWord.joined(separator: " ")
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
        initialWordsCount = listOfWords.count
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
        if(!isRoundInProgress) {
            newRound()
        }
    }
}

