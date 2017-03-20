//
//  ViewController.swift
//  Caty
//
//  Created by zhangyun on 22/02/2017.
//  Copyright (c) 2017 zhangyun. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.view.backgroundColor = UIColor.red
        
        let webImageUrl = "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-2.jpg"
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        self.view.addSubview(imageView)
        imageView.cy.setImage(with: URL(string:webImageUrl), placeholder: nil, progressBlock: { (progress, total) in
            NSLog("progress\(progress)--total\(total)")
        }) { (image, error, url) in
            NSLog("error\(error)")
        }
        
    }

}
