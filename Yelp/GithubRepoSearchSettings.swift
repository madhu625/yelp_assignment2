
//
//  GithubRepoSearchSettings.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation


class GithubRepoSearchSettings {
    var searchString: String?
    var categories: [String]?
    var deals: BooleanLiteralType?
    
    var minStars = 0
    
    init() {
        
    }
}