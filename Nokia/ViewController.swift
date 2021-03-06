//
//  ViewController.swift
//  Nokia
//
//  Created by Jonathan on 05.03.19.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextView!
    var letters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.letters = Array("abcdefghijklmnopqrstuvwxyz")
        
        for view in self.view.subviews as [UIView] {
            
            if let btn = view as? NokiaButton {
                
                btn.view.layer.cornerRadius = 20
                
                if btn.tag == 9 {
                    let tap = UITapGestureRecognizer(target: self, action: #selector(insertSpace(_:)))
                    tap.numberOfTapsRequired = 1
                    btn.addGestureRecognizer(tap)
                }
                
                guard btn.tag != 9 && btn.tag > 0 else { continue }
                
                let oneTap = UITapGestureRecognizer(target: self, action: #selector(tappedButton(_:)))
                oneTap.numberOfTapsRequired = 1
                
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tappedButton(_:)))
                doubleTap.numberOfTapsRequired = 2
                
                let tripleTap = UITapGestureRecognizer(target: self, action: #selector(tappedButton(_:)))
                tripleTap.numberOfTapsRequired = 3
                
                oneTap.require(toFail: doubleTap)
                oneTap.require(toFail: tripleTap)
                
                doubleTap.require(toFail: tripleTap)
                
                btn.addGestureRecognizer(oneTap)
                btn.addGestureRecognizer(doubleTap)
                btn.addGestureRecognizer(tripleTap)
                
                if btn.tag == 6 || btn.tag == 8 {
                    let quatroTap = UITapGestureRecognizer(target: self, action: #selector(tappedButton(_:)))
                    quatroTap.numberOfTapsRequired = 4
                    
                    tripleTap.require(toFail: quatroTap)
                    btn.addGestureRecognizer(quatroTap)
                }
            }
        }
        styleTextView()
        self.textField.becomeFirstResponder()
    }
    
    func styleTextView() {
        self.textField.layer.cornerRadius = 10
        self.textField.layer.borderColor = UIColor.black.cgColor
        self.textField.layer.borderWidth = 5
    }
    
    enum Tap: Int {
        case first = -1, second, third, fourth
    }
    
    func getLetter(from recognizer: UITapGestureRecognizer, at index: Int) -> Character? {
        guard let buttonTag = recognizer.view?.tag else { return nil }
        let letterIndex = buttonTag < 7 ? (buttonTag == 1 ? buttonTag : (buttonTag * 3) - 2) : (buttonTag * 3) - 1
        let letter = self.letters[letterIndex + index]
        return letter
    }
    
    func tapped(_ button: UITapGestureRecognizer, time: Tap) {
        if let letter = self.getLetter(from: button, at: time.rawValue) {
            self.textField.text?.append(letter)
        }
    }
    
    @objc func insertSpace(_ button: UITapGestureRecognizer) {
        self.textField.text?.append(" ")
    }
    
    @objc func tappedButton(_ button: UITapGestureRecognizer) {
        switch button.numberOfTapsRequired {
        case 1:
            self.tapped(button, time: .first)
        case 2:
            self.tapped(button, time: .second)
        case 3:
            self.tapped(button, time: .third)
        case 4:
            self.tapped(button, time: .fourth)
        default:
            break
        }
    }
    @IBAction func deleteLastCharacter(_ sender: Any) {
        if self.textField.text?.count ?? 0 > 0 {
            self.textField.text?.removeLast()
        }
    }
}

