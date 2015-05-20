//
//  QuestionViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
    }
}