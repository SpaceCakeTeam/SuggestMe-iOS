//
//  QuestionsTableViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
    }
}

