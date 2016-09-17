//
//  AddEditTeamView.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 08/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit


protocol AddEditTeamViewDelegate: class {
    func createdNewTeam(_ team: Team, addEditTeamView: AddEditTeamView)
    func deletedTeam(_ team: Team, addEditTeamView: AddEditTeamView)
}

final class AddEditTeamView: UIView {

    weak var delegate: AddEditTeamViewDelegate?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var firstPlayerTextField: UITextField!
    @IBOutlet weak var secondPLayerTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteParenViewHeightConstraint: NSLayoutConstraint!
    
    weak var editingTeam: Team?
    
    override func awakeFromNib() {
        isHidden = true
        
        self.firstPlayerTextField.delegate = self
        self.secondPLayerTextField.delegate = self
        self.teamNameTextField.delegate = self
        
    }
    
    func showAnimated() {
        
        deleteParenViewHeightConstraint.constant = 0
        
        backgroundView.alpha = 0
        dialogView.alpha = 0
        dialogView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        isHidden = false
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
            self.backgroundView.alpha = 1
            self.dialogView.alpha = 1
            self.dialogView.transform = CGAffineTransform(translationX: 0, y: 60)
            }) { (finished) in
                
                delay(seconds: 0.15, completion: {
                    self.teamNameTextField.becomeFirstResponder()
                    UIView.animate(withDuration: 0.4, animations: {
                        self.dialogView.transform = CGAffineTransform.identity
                    })
                })
        }
    }
    
    // MARK: Private
    
    fileprivate func close() {
        self.firstPlayerTextField.resignFirstResponder()
        self.secondPLayerTextField.resignFirstResponder()
        self.teamNameTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dialogView.alpha = 0;
            self.dialogView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.backgroundView.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
        }) 
    }
    
    // MARK: Animation Fake Views
    
    func teamLabel() -> UILabel {
        let teamLabel = UILabel()
        teamLabel.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)
        teamLabel.font = teamNameTextField.font
        teamLabel.text = teamNameTextField.text
        teamLabel.layer.masksToBounds = false
        dialogView.addSubview(teamLabel)
        teamLabel.frame.size.height = teamNameTextField.frame.height
        teamLabel.sizeToFit()
        teamLabel.center = teamNameTextField.center
        teamNameTextField.alpha = 0
        
        return teamLabel
    }
    
    func firstPlayerLabel() -> UILabel {
        let firstPlayerLabel = UILabel()
        firstPlayerLabel.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)
        firstPlayerLabel.font = firstPlayerTextField.font
        firstPlayerLabel.text = firstPlayerTextField.text
        firstPlayerLabel.layer.masksToBounds = false
        dialogView.addSubview(firstPlayerLabel)
        firstPlayerLabel.frame.size.height = firstPlayerTextField.frame.height
        firstPlayerLabel.sizeToFit()
        firstPlayerLabel.center = firstPlayerTextField.center
        firstPlayerTextField.alpha = 0
        
        return firstPlayerLabel
    }
    
    func secondPlayerLabel() -> UILabel {
        let secondPlayerLabel = UILabel()
        secondPlayerLabel.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)
        secondPlayerLabel.font = secondPLayerTextField.font
        secondPlayerLabel.text = secondPLayerTextField.text
        secondPlayerLabel.layer.masksToBounds = false
        dialogView.addSubview(secondPlayerLabel)
        secondPlayerLabel.frame.size.height = secondPLayerTextField.frame.size.height
        secondPlayerLabel.sizeToFit()
        secondPlayerLabel.center = secondPLayerTextField.center
        secondPLayerTextField.alpha = 0
        
        return secondPlayerLabel
    }
    
    // MARK: Action
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        //delegate?.deletedTeam(Team(), addEditTeamView: self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        close()
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        if let team = editingTeam {
            team.teamName = teamNameTextField.text!
            team.firstPlayer = firstPlayerTextField.text!
            team.secondPlayer = secondPLayerTextField.text!
            
            self.delegate?.createdNewTeam(team, addEditTeamView: self)
        } else {
            let team = Team(firstPlayer: firstPlayerTextField.text!, secondPlayer: secondPLayerTextField.text!, teamName: teamNameTextField.text!)
            self.delegate?.createdNewTeam(team, addEditTeamView: self)
        }
    }
}

// MARK: UITextFieldDelegate

extension AddEditTeamView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == teamNameTextField {
            firstPlayerTextField.becomeFirstResponder()
        } else if textField == firstPlayerTextField {
            secondPLayerTextField.becomeFirstResponder()
        } else if textField == secondPLayerTextField {
            if let empty = teamNameTextField.text?.isEmpty , empty {
                teamNameTextField.becomeFirstResponder()
            } else if let empty = firstPlayerTextField.text?.isEmpty , empty {
                firstPlayerTextField.becomeFirstResponder()
            } else {
                self.createButtonClicked(UIButton())
            }
        }
        
        return true
    }
    
}