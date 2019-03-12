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
                        margin-top: 0;
                        margin-bottom: 0;
                    }
                    .petition-body {
                        margin-top: 1.2rem;
                        margin-bottom: 1.2rem;
                    }
                    .signature-container {
                        text-align: right;
                    }
                    .signature-number {
                        font-size: 1.5em;
                        font-weight: bold;
                        color: #776CE0;
                    }
                </style>
            </head>
            <body>
                <header class="title-header">
                    <h1 class="title">\(petition.title)</h1>
                </header>
                <section class="petition-body">
                    <p>
                        \(petition.body)
                    </p>
                </section>
                <footer>
                    <div class="signature-container">
                        <span class="signature-number">\(petition.signatureCount)</span><span> signatures</span>
                    </div>
                </footer>
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
