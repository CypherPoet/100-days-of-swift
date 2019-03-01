//
//  ViewController.swift
//  Easy Browser
//
//  Created by Brian Sipple on 1/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @objc dynamic var webView: WKWebView!
    var progressView: UIProgressView!
    var urlsToChoose = [URL]()
    
    let siteNames = [
        "hackingwithswift.com",
        "google.com",
        "yalls.org",
        "developer.apple.com/develop"
    ]

    var progressObserver: NSKeyValueObservation! = nil
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.allowsBackForwardNavigationGestures = true
        
        setupNavigationBar()
        setupToolbar()
        observeProgress()
    }
    
    func observeProgress() {
        progressObserver = self.observe(\.webView.estimatedProgress) { [unowned self] (_, _) in
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "🌐",
            style: .plain,
            target: self,
            action: #selector(openSitePicker)
        )
    }
    
    
    func setupToolbar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    
    @objc func openSitePicker() {
        let alertController = UIAlertController(
            title: "Surf the Web!",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for siteName in siteNames {
            alertController.addAction(UIAlertAction(title: siteName, style: .default, handler: openPage))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alertController, animated: true)
    }
    
    
    func openPage(action: UIAlertAction) {
        guard let domainName = action.title else { return }
        guard let pageURL = URL(string: "https://\(domainName)") else { return }
        
        webView.load(URLRequest(url: pageURL))
    }
}


extension ViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for siteName in siteNames {
                if host.contains(siteName) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
