//
//  AboutViewController.swift
//  JenkinsiOS
//
//  Created by Robert on 08.12.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var creditsTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var aboutViewHeight: NSLayoutConstraint!
    @IBOutlet weak var creditsViewHeight: NSLayoutConstraint!
    
    let aboutInformationManager = AboutInformationManager()
    var reviewHandler: ReviewHandler?
    
    @IBAction func review(_ sender: Any) {
        reviewHandler?.triggerReview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        aboutTextView.text = aboutInformationManager.getAboutText() ?? ""
        creditsTextView.text = aboutInformationManager.getCreditsText() ?? ""
        
        reviewHandler = ReviewHandler(presentOn: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

//        aboutTextView.sizeToFit()
        var previousSize = CGSize(width: aboutTextView.frame.size.width,
                                  height: CGFloat(MAXFLOAT))
        var newSize = aboutTextView.sizeThatFits(previousSize)
        aboutViewHeight.constant = newSize.height
//        creditsTextView.sizeToFit()
        previousSize = CGSize(width: creditsTextView.frame.size.width,
                             height: CGFloat(MAXFLOAT))
        newSize = creditsTextView.sizeThatFits(previousSize)
        creditsViewHeight.constant = newSize.height

        scrollView.contentSize = stackView.frame.size
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
    }
}
