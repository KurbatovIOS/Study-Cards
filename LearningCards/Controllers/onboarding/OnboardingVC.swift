//
//  OnboardingVC.swift
//  Study Cards
//
//  Created by Kurbatov Artem on 17.10.2022.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.cornerRadius = 10
        skipButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func skipButtonClicked(_ sender: Any) {
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
    }
    

}
