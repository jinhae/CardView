//
//  CardView.swift
//  CardView
//
//  Created by 모바일보안팀 on 22/03/2019.
//  Copyright © 2019 모바일보안팀. All rights reserved.
//

import UIKit

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



class CardView: UIScrollView, UIScrollViewDelegate {
    //Content View MaxScale
    let contentViewMaxScale:CGFloat = 0.2
    
    // Content MainView
    var mainContentView:UIView!
    
    //화면에서 content view가 차지하는 비율
    let contentViewWidthRatio:CGFloat           = 0.6
    let contentViewHeightRatio:CGFloat          = 0.6
    
    // content view사이의 거리
    let betweenContentViewHorizonDistanceRatio:CGFloat = 0.5
    let betweenContentViewVeritcalDistanceRatio:CGFloat = 0
    
    
    // contentview 개수
    let contentHorizonViewCount = 20
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
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        
        self.mainContentView.frame = CGRect(x: self.contentOffset.x * ((self.contentSize.width - self.mainContentView.frame.width) / (self.contentSize.width - self.visibleSize.width)), y: 0, width: self.mainContentView.frame.width, height: self.mainContentView.frame.height)
        
        
        let index = Int(self.currentIndex)
        let nextIndex = index + 1

        let scalePoint =  1 + (self.contentViewMaxScale / 1.0) * (self.currentIndex - CGFloat(index))
        let scalePointRevers =  (1.0 + self.contentViewMaxScale) - (self.contentViewMaxScale / 1.0) * (self.currentIndex - CGFloat(index))
        
        self.mainContentView.subviews[index].scale(defaultSize: CGSize(width: self.contentViewWidth, height: self.contentViewHeight), scale: scalePointRevers)
        if nextIndex < self.mainContentView.subviews.count{
            self.mainContentView.subviews[nextIndex].scale(defaultSize: CGSize(width: self.contentViewWidth, height: self.contentViewHeight), scale: scalePoint)
        }
        
    }

    
    
    func initialize(){
        // mainContentView 초기화
        self.mainContentView = UIView(frame: CGRect(x: 0, y: 0, width: self.mainContentViewSize.width , height: self.mainContentViewSize.height))
        self.addSubview(self.mainContentView)
        self.mainContentView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        self.contentSize = CGSize(width: self.visibleSize.width * CGFloat(self.contentHorizonViewCount), height: self.visibleSize.height)
        print("\(self.mainContentView.frame.width)")
        print("ratio \(self.mainContentView.frame.width / self.contentSize.width)")
        
        // ContentView  추가
        let contentView = UIView(frame: CGRect(
            x: self.defaultViewCenter.x - (self.contentViewWidth / 2),
            y: self.defaultViewCenter.y - (self.contentViewHeight / 2),
            width: self.contentViewWidth,
            height: self.contentViewHeight))
        contentView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        contentView.scale(defaultSize: CGSize(width: self.contentViewWidth, height: self.contentViewHeight), scale: (1.0 + self.contentViewMaxScale))
        self.mainContentView.addSubview(contentView)
        
        for index in 1..<self.contentHorizonViewCount{
            let x = self.defaultViewCenter.x - (self.contentViewWidth / 2) + ((self.contentViewWidth + self.betweenContentViewHorizonDistance)*CGFloat(index))
            let y = self.defaultViewCenter.y - (self.contentViewHeight / 2)
            
            
            
            let contentView = UIView(frame: CGRect(
                x: x,
                y: y,
                width: self.contentViewWidth,
                height: self.contentViewHeight))
            
            contentView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            self.mainContentView.addSubview(contentView)
        }
    }
    
    
    var contentHorizonViewIndex:Int{
        set{
            self.scrollRectToVisible(
                CGRect(x: (self.contentViewWidth + betweenContentViewHorizonDistance) * CGFloat(newValue - 1),
                       y: self.contentOffset.y,
                       width: self.frame.width,
                       height: self.frame.height),
                animated: false)
        }
        get{
            
            for index in 1...self.contentHorizonViewCount{
                if (self.contentOffset.x >= ((self.contentViewWidth + betweenContentViewHorizonDistance) * CGFloat(index - 1))) &&
                    (self.contentOffset.x <= ((self.contentViewWidth + betweenContentViewHorizonDistance) * CGFloat(index ))){
                    
                    self.scrollRectToVisible(
                        CGRect(x: (self.contentViewWidth + betweenContentViewHorizonDistance) * CGFloat(index),
                               y: self.contentOffset.y,
                               width: self.frame.width,
                               height: self.frame.height),
                        animated: true)
                    
                    
                    
                    
                    return index
                }
            }
            return 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.initialize()
        self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("\(change![.newKey])")
    }
    
    
    
    override func draw(_ rect: CGRect) {
        print("\(rect.debugDescription)")
    }

}
