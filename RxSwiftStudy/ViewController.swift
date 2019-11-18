//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by cjyang on 06/11/2019.
//  Copyright © 2019 cjyang. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let vm = ObservableTestViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        vm.driverTest()
    }

}

