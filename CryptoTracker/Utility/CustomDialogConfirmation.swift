//
//  CustomDialogConfirmation.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-11-04.
//

import UIKit

class CustomDialogConfirmation: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        let width: CGFloat = 50
        let height: CGFloat = 50
        
        let viewRect = CGRect(x: round(bounds.size.width - width) / 2, y: round(bounds.size.height - height) / 2, width: width, height: height)

        let path = UIBezierPath(roundedRect: viewRect, cornerRadius: 10)
        
        UIColor.systemGray6.setFill()
        path.fill() // filling the color to the path
        
        guard let image = UIImage(systemName: "heart.fill")?.withTintColor(.red) else { return }
        
        image.draw(in: CGRect(x: center.x-10, y: center.y-8, width: 20, height: 17))
        
    }
    
    func showDialog(){
        alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
    }
}
