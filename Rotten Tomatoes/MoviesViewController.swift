//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Jiheng Lu on 10/25/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

import UIKit
import PKHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // --------------- set up global variables ---------------
    @IBOutlet weak var httpErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!
    var refreshControl: UIRefreshControl!
    var picCache: [NSArray]!

    // --------------- set up app life cycle ---------------
    override func viewDidLoad() {
        super.viewDidLoad()

        httpErrorView.hidden = true

        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()

        delay(2, closure: {
            self.fetchData()
        })

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // --------------- fetch data ---------------
    func fetchData() {
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    NSLog("response1: \(requestError)")
                    self.showHttpError()
                } else if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("rsp-cnt-success: \(data.length)")

                            self.movies = (responseDictionary["movies"] as! [NSDictionary])
                            self.filteredData = self.movies
                            self.tableView.reloadData()
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    } else {
                        NSLog("rsp-cnt-fails: \(data.length)")
                    }
                } else if let rsp = responseOrNil {
                    NSLog("response2: \(rsp)")
                    self.showHttpError()
                }
        });
        task.resume()
        PKHUD.sharedHUD.hide()
    }

    func onRefresh() {
        delay(1, closure: {
            self.fetchData()
            self.refreshControl.endRefreshing()
        })
    }

    func showHttpError() {
        httpErrorView.alpha = 0
        httpErrorView.hidden = false

        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseIn, animations: {
                self.httpErrorView.alpha = 0.95
            }, completion: { finished in
                UIView.animateWithDuration(1, delay: 2, options: .CurveEaseOut, animations: {
                        self.httpErrorView.alpha = 0
                    }, completion: { finished in
                        self.httpErrorView.hidden = true
                })
        })
    }

    @IBAction func errorOnTap(sender: AnyObject) {
        showHttpError()
    }

    // --------------- set up tableView ---------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String

        let placeholder = UIImage(named: "placeholder.png");
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        let url_request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)

        let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(url_request)
        if (cachedImage != nil) {
            cell.posterView.image = cachedImage
        } else {
            let imageRequestSuccess = {
                (request : NSURLRequest!, response : NSHTTPURLResponse?, image : UIImage!) -> Void in
                cell.posterView.image = image;
                UIView.transitionWithView(cell.posterView, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: nil, completion: nil)
            }
            cell.posterView.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: imageRequestSuccess, failure: nil)
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // --------------- set up SearchBar ---------------
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (filteredData != nil) {
            filteredData = searchText.isEmpty ? movies : movies!.filter(
                {(movie: NSDictionary) -> Bool in
                    return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                }
            )
        }
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        view.endEditing(true)

        filteredData = movies
        tableView.reloadData()
        if (filteredData != nil) {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        view.endEditing(true)

        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }

    // --------------- set up Navigation ---------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = filteredData![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        movieDetailsViewController.placeholder = cell.posterView.image!
    }

    // --------------- helper methods ---------------
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}