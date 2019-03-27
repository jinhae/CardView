//
//  ViewController.swift
//  CardView
//
//  Created by 모바일보안팀 on 22/03/2019.
//  Copyright © 2019 모바일보안팀. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var scrollView: CardView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func TestButton(_ sender: Any) {
        self.scrollView.isScrollEnabled = true
        print(self.scrollView.contentHorizonViewIndex)
    }
    
    
    var index: Int = 0
    @IBAction func nextAction(_ sender: Any) {
//        self.scrollView.moveNext()
        index += 1
        self.scrollView.contentHorizonViewIndex = index
        print(index)
        
    }
    @IBAction func beforAction(_ sender: Any) {
//        self.scrollView.moveBefore()
        index -= 1
        self.scrollView.contentHorizonViewIndex = index
        print(index)
    }
    
    

}

