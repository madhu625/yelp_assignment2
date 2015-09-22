//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {

    var businesses: [Business]!
    // Search bar should be in the navigation bar
    // This is just a UISearchBar that is set as the navigationItem.titleView
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()
    //var results: Array<> = []
    var offset: Int = 0
    var total: Int!
    let limit: Int = 20
    var lastResponse: NSDictionary!
    var client: YelpClient!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // add search bar to navigation bar
        searchBar.sizeToFit()
        self.searchBar.placeholder = "e.g. sushi, cheeseburger"
        navigationItem.titleView = searchBar

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
       
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (businesses?.count ?? 0)
        return businesses?.count ?? 0
    }
    
    
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath:indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }

    // For send back selected filters
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String :
        AnyObject]) {
            
            var categories = filters["categories"] as? [String]
            Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
                (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
                
            }
    }
    
    
    //nav search start
    
        func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(true, animated: true)
            return true;
        }
        
        func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(false, animated: true)
            return true;
        }
        
        func searchBarCancelButtonClicked(searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            searchSettings.searchString = searchBar.text
            
            searchBar.resignFirstResponder()
            doSearch()
        }
    
    private func doSearch() {
        Business.searchWithTerm(searchSettings.searchString!, sort: nil , categories: searchSettings.categories, deals: searchSettings.deals) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }

    }
    
    //nav search end

}




