//
//  ViewController.swift
//  StarButton
//
//  Created by luojie on 3/21/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBAction func changeSelectState(sender: StarButton) {
        sender.isFavorite = !sender.isFavorite
    }


}

