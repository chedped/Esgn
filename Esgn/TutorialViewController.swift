//
//  TutorialViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

typealias TutorialCompletion = (Void) -> Void

class TutorialViewController: MWZBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentWidth: UIView!
    @IBOutlet weak var lcContentWidth: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var btnSkip: UIButton!
    
    var completion: TutorialCompletion?
    var tutorials: [Tutorial]!
    var getstart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(1, forKey: "tutorial")
        UserDefaults.standard.synchronize()
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareView()
    }

    func prepareView() {
        
        var startX: CGFloat = 0
        let width: CGFloat = scrollView.frame.size.width
        let height: CGFloat = scrollView.frame.size.height
        
        for tutorial in tutorials {
            
            let imgView = UIImageView()
            imgView.frame = CGRect(x: startX, y: 0, width: width, height: height)
            imgView.sd_setImage(with: URL(string: tutorial.image_url))
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            
            contentWidth.addSubview(imgView)
            
            startX = startX + width
        }
        
        lcContentWidth.constant = startX
        pageControl.numberOfPages = tutorials.count
        loadingView.stopAnimating()
    }

    @IBAction func onSkip( _ sender: AnyObject ) {
        
        if getstart == true {
            if completion != nil {
                completion!()
            }
            
            dismiss(animated: true, completion: nil)
        }
        else {
            btnSkip.setTitle("PRESS START", for: .normal)
            scrollView.isHidden = true
            pageControl.isHidden = true
        }
        getstart = true
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
}
