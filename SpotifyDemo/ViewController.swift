//
//  ViewController.swift
//  SpotifyDemo
//
//  Created by Angel Vazquez on 3/2/16.
//  Copyright © 2016 Angel Vázquez. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate  {
    
    // Info from Spotify Developer page
    
    /*
    * NOTE - Try making a demo project using your info
    */
    let kClientID = "067c71349027463b89648f7ac37565f5"
    let kCallbackURL = "spotify-demo://hello"
    let kTokenSwapURL = "http://localhost:1234/swap"
    let kTokenRefreshURL = "http://localhost:1234/refresh"
    
    // Spotify Setup
    var player = SPTAudioStreamingController?()
    let spotifyAuthenticator = SPTAuth.defaultInstance()
    var loginSession = SPTSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Needed to let users use the Info Center (Now Playing) controls
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }

    @IBAction func loginWithSpotify(sender: AnyObject) {
        
        // Basic Setup for App
        
        // Use your apps client id - found in developer.spotify.com
        spotifyAuthenticator.clientID = kClientID
        
        // Tells the user what services your app will use
        spotifyAuthenticator.requestedScopes = [SPTAuthStreamingScope]
        
        // User your apps redirect url - found in developer.spotify.com
        spotifyAuthenticator.redirectURL = NSURL(string: kCallbackURL)
        
        // Use only when you have an application setup for this
        //spotifyAuthenticator.tokenSwapURL = NSURL(string: kTokenSwapURL)
        //potifyAuthenticator.tokenRefreshURL = NSURL(string: kTokenRefreshURL)
        
        // Create a Spotify Login View Controller
        let spotifyAuthenticationViewController = SPTAuthViewController.authenticationViewController()
        spotifyAuthenticationViewController.delegate = self
        
        // Spotify Login View Controller Setup
        spotifyAuthenticationViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        spotifyAuthenticationViewController.definesPresentationContext = true
        
        // Present Spotify Login View Controller
        presentViewController(spotifyAuthenticationViewController, animated: false, completion: nil)
        
    }
    
    // MARK: - SPTAuthViewDelegate 
    
    // This functions gets called only if your login was succesful.
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        
        // Current User Session
        self.loginSession = session
            
        // Goes to Playlists View
        self.performSegueWithIdentifier("NowPlayingSegue", sender: self)
    }
    
    // Only gets called when there was an error during login
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("Login failed... \(error)")
       
    }
    
    // Only gets called when user cancels the log in
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("Did Cancel Login...")
    }    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NowPlayingSegue" {
            
            let destinationViewController: NowPlayingViewController = segue.destinationViewController as! NowPlayingViewController
            
            // Send current Spotify Session
            destinationViewController.currentSession = loginSession
        }
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

