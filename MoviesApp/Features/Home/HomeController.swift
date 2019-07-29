//
//  ViewController.swift
//  MoviesApp
//
//  Created by Palmsoft  on 25/07/19.
//  Copyright © 2019 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class HomeController: UIViewController {

    @IBOutlet var textMessage: UILabel!
    
    var delay: Int!
    var time: Int!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    setupTimer()
    conectionChecker()
        
    textMessage.fadeTransition(0.2)
    textMessage.text = "Hi, Just a moment while I'm packing some things!"
    }
}

private extension HomeController {
    
    // MARK: - Setup
    func setupTimer() {
        delay = 0
        time = 1
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
    }
    
    func conectionChecker() {
        let haveInternet = Connectivity.isConnectedToInternet
        let haveData = DBService.shared.getMovies().count
        
        if  haveInternet {
            delay = 1
        } else if !haveInternet && haveData > 0 {
            delay = 11
            textMessage.fadeTransition(0.2)
            textMessage.text = "Unfortunately you are not connected to the internet, but I have some upcoming movies that you may not have see yet!"
        } else {
            timer.invalidate()
            textMessage.fadeTransition(0.2)
            textMessage.text = "Unfortunately I have no upcoming movies to show you, connect the internet for new movies. Please connect to the internet and restart the application. "
        }
    }
    
    // MARK: - Present Articles
    func presentMovies() {
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Movie") as! UINavigationController
        self.present(viewController, animated: false, completion: nil)
    }
    
    // MARK: - TIMER LOOP
    @objc func loop() {
        
        if delay >= 1 {
            delay += 1
        }
        if delay == 4{
        textMessage.fadeTransition(0.2)
        textMessage.text = "Ok, you are connected to the internet. Just a second while I get the latest upcoming movie for you"
        }
        if delay == 6{
            DBService.shared.deleteAllFromDatabase()
        }
        if delay == 8{
            MovieService.shared.getGenres()
        }
        if delay == 10{
            MovieService.shared.getMovies()
            textMessage.fadeTransition(0.2)
            textMessage.text =  "All right, Let's go to the movies ..."
        }
        if time == 13{
            presentMovies()
        }
        time += 1
    }
}

// MARK: - Conection Checker
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}




