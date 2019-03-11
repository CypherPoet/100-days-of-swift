//
//  PetitionDetailViewController.swift
//  Whitehouse Petitions
//
//  Created by Brian Sipple on 3/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import WebKit

class PetitionDetailViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var webView: WKWebView!
    var petition: Petition!
    
    var htmlString: String {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>\(petition.title)</title>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    html {
                        font-size: 100%;
                    }
                    body {
                        font-size: 1.2rem;
                        padding: 1.25rem 1rem;
                    }
                    .title {
                    }
                    .petition-body {
                        margin-top: 1.2rem;
                    }
                </style>
            </head>
            <body>
                <header>
                    <h1 class="title">\(petition.title)</h1>
                </header>
                <section class="petition-body">
                    <p>
                        \(petition.body)
                    </p>
                </section>
            </body>
            </html>
            """
    }
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard petition != nil else { return }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    
    
    // MARK: - Core Methods
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
