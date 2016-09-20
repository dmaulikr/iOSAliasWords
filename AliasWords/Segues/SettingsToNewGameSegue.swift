//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class SettingsToNewGameSegue: UIStoryboardSegue {
    
    override func perform() {
        let settingsViewController = source as! SettingsViewController
        
        settingsViewController.navigationController?.delegate = self
        let _ = settingsViewController.navigationController?.popViewController(animated: true)
    }
}

extension SettingsToNewGameSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension SettingsToNewGameSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: SettingsViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! SettingsViewController
        let toViewController: NewGameViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! NewGameViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        

        
//        bottom buttton animation
        let buttonLabel = UILabel()
        buttonLabel.textAlignment = .center
        buttonLabel.backgroundColor = toViewController.startTheGameButton.backgroundColor
        //buttonLabel.text = fromViewController.playButton.titleLabel?.text
        buttonLabel.text = toViewController.startTheGameButton.titleLabel?.text
        buttonLabel.font = fromViewController.playButton.titleLabel?.font
        buttonLabel.textColor = fromViewController.playButton.titleLabel?.textColor
        containerView.addSubview(buttonLabel)
        buttonLabel.frame = fromViewController.playButton.frame
        buttonLabel.layer.cornerRadius = fromViewController.playButton.layer.cornerRadius
        buttonLabel.layer.masksToBounds = fromViewController.playButton.layer.masksToBounds
        
        fromViewController.playButton.alpha = 0
        delay(seconds: 0.1) {
            buttonLabel.animateToFont(toViewController.startTheGameButton.titleLabel!.font, withDuration: 0.3)
            UIView.animate(withDuration: 0.3, animations: {
                buttonLabel.center = toViewController.startTheGameButton.superview!.convert(toViewController.startTheGameButton.center, to: nil)
                
                buttonLabel.transform = CGAffineTransform(scaleX: toViewController.startTheGameButton.frame.width/buttonLabel.frame.width, y: toViewController.startTheGameButton.frame.height/buttonLabel.frame.height)
            }) { (_) in
                delay(seconds: 0.2, completion: {
                    buttonLabel.removeFromSuperview()
                })
            }
        }
        
        // not playing
        let notPlayingCells = toViewController.tableView.visibleCells.filter { cell -> Bool in
            let index = toViewController.tableView.indexPath(for: cell)!.section
            return !toViewController.teams[index].playing
        }
        
        notPlayingCells.forEach {
            $0.alpha = 0.5
        }
        toViewController.tableView.tableFooterView?.alpha = 0
        delay(seconds: 0.3) { 
            UIView.animate(withDuration: 0.2, animations: { 
                fromViewController.view.alpha = 0
            })
            toViewController.tableView.tableFooterView?.fadeUp()
        }
        
        // animate cells to labels
        let playingCells = toViewController.tableView.visibleCells.filter { cell in
            let index = toViewController.tableView.indexPath(for: cell)!.section
            return toViewController.teams[index].playing
        } . flatMap { cell -> NewGameTableViewCell? in
            return cell as? NewGameTableViewCell
        }
        
        let firstCellPosition = Int(toViewController.tableView.indexPath(for: playingCells[0])!.section)
        let offset = toViewController.teams[0..<firstCellPosition].filter {
            return $0.playing
        }.count
        
        
        playingCells.enumerated().forEach { (index, cell) in
            
            let indexWithOffset = index + offset
            let stackView = (indexWithOffset % 2 == 0 ? fromViewController.leftStackView : fromViewController.rightStackView)!
            let stackIndex = indexWithOffset/2
            
            let stackLabel = stackView.arrangedSubviews[stackIndex] as! UILabel
            
            // create animation view - cell
            let view = UIView()
            containerView.addSubview(view)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.frame = stackView.convert(stackLabel.frame, to: nil)
            view.backgroundColor = stackLabel.backgroundColor
            
            let label = UILabel()
            label.text = stackLabel.text
            label.textColor = stackLabel.textColor
            view.addSubview(label)
            label.sizeToFit()
            label.center = CGPoint(x: stackLabel.frame.width/2, y: stackLabel.frame.height/2)//(stackView.arrangedSubviews[0] as! UILabel).center
            
            cell.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                
                fromViewController.leftStackView.superview?.alpha = 0
                }, completion: { (_) in
                    
                    delay(seconds: 0.3, completion: {
                        label.textColor = cell.teamNameLabel.textColor
                    })
                    
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
                        cell.alpha = 1
                        view.alpha = 0
                        }, completion: { (_) in
                            view.removeFromSuperview()
                    })
                    
                    UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
                        view.backgroundColor = cell.backgroundColor
                        view.frame = cell.superview!.convert(cell.frame, to: nil)
                        label.frame = cell.teamNameLabel.frame
                        }, completion: { (_) in
                            // end
                            transitionContext.completeTransition(true)
                    })
            })
        }
    }

}




