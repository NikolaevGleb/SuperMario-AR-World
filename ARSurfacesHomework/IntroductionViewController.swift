//
//  IntroductionViewController.swift
//  ARSurfacesHomework
//
//  Created by Глеб Николаев on 24.09.2018.
//  Copyright © 2018 Глеб Николаев. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var firstPhrasesStackView: UIStackView!
    
    @IBOutlet weak var secondPhrasesStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondPhrasesStackView.isHidden = true

    }
    
    @IBAction func firstButtonPressed(_ sender: UIButton) {
        
        firstPhrasesStackView.isHidden = true
        secondPhrasesStackView.isHidden = false
        
    }
    
    @IBAction func startGameButton(_ sender: UIButton) {
        performSegue(withIdentifier: "startGame", sender: sender)
    }
    
}
