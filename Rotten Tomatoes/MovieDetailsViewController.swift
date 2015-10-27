//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Jiheng Lu on 10/25/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailsView: UIView!

    var movie: NSDictionary!
    var placeholder = UIImage(named: "placeholder.png")!
    let detailsViewTransitionDistance = CGFloat(330)
    var detailsViewMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up background image
        let org_url = movie.valueForKeyPath("posters.original") as! String
        let cache_url = NSURL(string: org_url)!
        imageView.setImageWithURL(cache_url, placeholderImage: placeholder)

        let range = org_url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)!
        let new_url = org_url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        let url = NSURL(string: new_url)!

        let url_request = NSURLRequest(URL: url)
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse?, image : UIImage!) -> Void in
            self.imageView.image = image;
            UIView.transitionWithView(self.imageView, duration: 1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: nil)
        }
        imageView.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: imageRequestSuccess, failure: nil)

        // set up title and synopsis
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        synopsisLabel.sizeToFit()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = synopsisLabel.bounds.height
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)

        // set up image-onTap-action
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        // set up swipe-down gesture
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.detailsView.addGestureRecognizer(swipeDown)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.detailsView.addGestureRecognizer(swipeUp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imageTapped(img: AnyObject) {
        if (detailsView.hidden == true) {
            navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.transitionWithView(detailsView, duration: 0.5, options: UIViewAnimationOptions.TransitionCurlDown, animations: nil, completion: nil)
            detailsView.hidden = false
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.transitionWithView(detailsView, duration: 0.5, options: UIViewAnimationOptions.TransitionCurlUp, animations: nil, completion: nil)
            detailsView.hidden = true
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                NSLog("Swiped up")

                if (self.detailsViewMoved == true) {
                    let xPosition = self.detailsView.frame.origin.x
                    let yPosition = self.detailsView.frame.origin.y - detailsViewTransitionDistance
                    let height = self.detailsView.frame.size.height
                    let width = self.detailsView.frame.size.width
                    UIView.animateWithDuration(0.5, animations: {
                        self.detailsView.frame = CGRectMake(xPosition, yPosition, height, width)
                    })
                    self.detailsViewMoved = false
                }
            case UISwipeGestureRecognizerDirection.Down:
                NSLog("Swiped down")

                if (self.detailsViewMoved == false) {
                    let xPosition = self.detailsView.frame.origin.x
                    let yPosition = self.detailsView.frame.origin.y + detailsViewTransitionDistance
                    let height = self.detailsView.frame.size.height
                    let width = self.detailsView.frame.size.width
                    UIView.animateWithDuration(0.5, animations: {
                        self.detailsView.frame = CGRectMake(xPosition, yPosition, height, width)
                    })
                    self.detailsViewMoved = true
                }
            default:
                break
            }
        }
    }

}
