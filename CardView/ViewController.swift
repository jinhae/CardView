//
//  ViewController.swift
//  CardView
//
//  Created by 이진해 on 22/03/2019.
//  Copyright © 2019 이진해. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardViewDataSource{

    @IBOutlet weak var scrollView: CardView!
    
    
    var cards = [UIView]()
    
    
    func cardViewNumberOfCards() -> Int {
        
        return cards.count
    }
    
    
    func cardViewWillDisplayCard(index: Int, frame: CGRect) -> UIView {
        cards[index].frame = frame
        return cards[index]
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uuid = NSUUID().uuidString
        print(uuid)
        
        print("viewController load")
        
        self.scrollView.dataSource = self
        
        let card1 = UIImageView()
        
        card1.image = UIImage.init(named: "card2")
        card1.contentMode = .scaleAspectFit
        cards.append(card1)
        
        
        let card2 = UIImageView()
        
        card2.image = UIImage.init(named: "card2")
        card2.contentMode = .scaleAspectFit
        cards.append(card2)
        
        
        let card3 = UIImageView()
        
        card3.image = UIImage.init(named: "card2")
        card3.contentMode = .scaleAspectFit
        cards.append(card3)
        
        
        let card4 = UIImageView()
        
        card4.image = UIImage.init(named: "card2")
        card4.contentMode = .scaleAspectFit
        cards.append(card4)
        
    }
}

