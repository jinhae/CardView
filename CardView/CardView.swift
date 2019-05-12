//
//  CardView.swift
//  CardView
//
//  Created by 이진해 on 22/03/2019.
//  Copyright © 2019 이진해. All rights reserved.
//

import UIKit



protocol CardViewDataSource{
    func cardViewNumberOfCards() -> Int
    func cardViewWillDisplayCard(index:Int, frame:CGRect) -> UIView
}


class CardView: UIScrollView, UIScrollViewDelegate {
    
    var dataSource: CardViewDataSource?
    
    var defaultIndex:Int = 0
    
    //Content View MaxScale
    let contentViewMaxScale:CGFloat = 0.2
    
    // Content MainView
    var mainContentView:UIView!
    
    //화면에서 content view가 차지하는 비율
    let contentViewWidthRatio:CGFloat           = 0.6
    let contentViewHeightRatio:CGFloat          = 0.6
    
    // content view사이의 거리
    let betweenContentViewHorizonDistanceRatio:CGFloat = 0.7
    let betweenContentViewVeritcalDistanceRatio:CGFloat = 0
    
    
    // contentview 개수
    var contentHorizonViewCount:Int{
        get{
            guard let count = dataSource?.cardViewNumberOfCards() else {return 0}
            return count
        }
    }
    let contentVerticalViewCount = 1
    
    // 최초 뷰 센터
    var defaultViewCenter:CGPoint{
        return CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
    }
    
    // contentView 가로
    var contentViewWidth:CGFloat{
        get{
            return self.frame.size.width  * self.contentViewWidthRatio
        }
    }
    
    // contentView 세로
    var contentViewHeight:CGFloat{
        get{
            return self.frame.size.height * self.contentViewHeightRatio
        }
    }
    
    // contentView 간 거리
    var betweenContentViewHorizonDistance:CGFloat{
        get{
            return horizonPadding * betweenContentViewHorizonDistanceRatio
        }
    }
    
    // contentView 간 거리
    var betweenContentViewVerticalDistance:CGFloat{
        get{
            return verticalPadding * betweenContentViewVeritcalDistanceRatio
        }
    }
    
    // content view  가로 맨끝 공간
    var horizonPadding:CGFloat{
        get{
            return (self.frame.size.width - self.contentViewWidth) / 2
        }
    }
    
    // content view 세로 맨끝 공간
    var verticalPadding:CGFloat{
        get{
            return (self.frame.size.height - self.contentViewHeight) / 2
        }
    }
    
    // 생성된 contentview들을 포함하는 mainContentView size
    var mainContentViewSize: CGSize{
        get{
            let width = ((self.horizonPadding * 2) + (self.contentViewWidth * CGFloat(self.contentHorizonViewCount))) + (self.betweenContentViewHorizonDistance * CGFloat(self.contentHorizonViewCount - 1))
            let height = ((self.verticalPadding * 2) + (self.contentViewHeight * CGFloat(self.contentVerticalViewCount))) + (self.betweenContentViewVerticalDistance * CGFloat(self.contentVerticalViewCount - 1))
            
            return CGSize(width: width, height: height)
        }
    }
    
    
    // Current Index
    var currentIndex:CGFloat {
        get{
            return self.contentOffset.x / self.frame.width
        }
    }
    
    func move(At index:Int){
        if (index >= 0) && (index < self.contentHorizonViewCount){
            self.setContentOffset(CGPoint(x: self.frame.width * CGFloat(index), y: 0), animated: true)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataSource != nil && self.contentHorizonViewCount > 1 && self.mainContentView != nil{
            self.mainContentView.frame = CGRect(x: self.contentOffset.x * ((self.contentSize.width - self.mainContentView.frame.width) / (self.contentSize.width - self.visibleSize.width)), y: 0, width: self.mainContentView.frame.width, height: self.mainContentView.frame.height)
            
            
            let index = Int(self.currentIndex)
            let nextIndex = index + 1
            
            let scalePoint =  1 + (self.contentViewMaxScale / 1.0) * (self.currentIndex - CGFloat(index))
            let alpha =  0.5 + (0.5 / 1.0) * (self.currentIndex - CGFloat(index))
            
            let scalePointReverse =  (1.0 + self.contentViewMaxScale) - (self.contentViewMaxScale / 1.0) * (self.currentIndex - CGFloat(index))
            let alphaReverse =  1.0 - (0.5 / 1.0) * (self.currentIndex - CGFloat(index))
            
            self.mainContentView.subviews[index].scale(defaultSize: CGSize(width: self.contentViewWidth, height: self.contentViewHeight), scale: scalePointReverse)
            self.mainContentView.subviews[index].alpha = alphaReverse
            
            
            if nextIndex < self.mainContentView.subviews.count{
                self.mainContentView.subviews[nextIndex].alpha = alpha
                self.mainContentView.subviews[nextIndex].scale(defaultSize: CGSize(width: self.contentViewWidth, height: self.contentViewHeight), scale: scalePoint)
            }
        }
    }
    
    
    
    func contentViewFrame(index:Int) -> CGRect {
        var contentFrame = CGRect()
        contentFrame.origin.x = self.defaultViewCenter.x - (self.contentViewWidth / 2) + ((self.contentViewWidth + self.betweenContentViewHorizonDistance) * CGFloat(index))
        contentFrame.origin.y  = self.defaultViewCenter.y - (self.contentViewHeight / 2)
        contentFrame.size.width = self.contentViewWidth
        contentFrame.size.height = self.contentViewHeight
        return contentFrame
    }
    
    func initialize(){
        // option
        self.isPagingEnabled = true
        
        
        
        // mainContentView 초기화
        self.mainContentView = UIView(frame: CGRect(x: 0, y: 0, width: self.mainContentViewSize.width , height: self.mainContentViewSize.height))
        self.addSubview(self.mainContentView)
        self.contentSize = CGSize(width: self.visibleSize.width * CGFloat(self.contentHorizonViewCount), height: self.visibleSize.height)
        
        for index in 0..<self.contentHorizonViewCount{
            guard let contentView = dataSource?.cardViewWillDisplayCard(index: index, frame: contentViewFrame(index: index)) else {return}
            if index == self.defaultIndex{
                contentView.scale(defaultSize: CGSize(width:self.contentViewWidth,height: self.contentViewHeight), scale: 1.0 + self.contentViewMaxScale)
                
                contentView.alpha = 1.0
                
            }else{
                contentView.alpha = 0.5
            }
            
            self.mainContentView.addSubview(contentView)
        }
        //        self.setContentOffset(CGPoint(x: self.frame.width * CGFloat(self.defaultIndex), y: 0), animated: false)
        
    }
    
    func updateCardView(){
        self.mainContentView.removeFromSuperview()
        initialize()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        
        
    }
    
    override func draw(_ rect: CGRect) {
        //        if self.subviews.count == 1 {
        //            self.mainContentView.removeFromSuperview()
        //        }
        initialize()
    }
    
}



extension UIView{
    func scale(defaultSize:CGSize, scale:CGFloat){
        let widthVector  = (defaultSize.width * scale) - defaultSize.width
        let heightVector = (defaultSize.height * scale) - defaultSize.height
        
        self.frame =  CGRect(x: self.center.x - (defaultSize.width + widthVector) / 2 ,
                             y: self.center.y - (defaultSize.height + heightVector) / 2 ,
                             width:    defaultSize.width + widthVector,
                             height:   defaultSize.height + heightVector)
    }
}
