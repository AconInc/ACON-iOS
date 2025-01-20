//
//  ACWebViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import UIKit

import WebKit

final class DRWebViewController: UIViewController {
    
    private var webView: WKWebView?
    
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        webView?.navigationDelegate = self
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
    }
    
    private func setWebView() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.load(request)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.showDefaultAlert(title: StringLiterals.WebView.error,
                                     message: StringLiterals.WebView.cantFindWebPage)
            }
            print("Invalid URL string.")
        }
    }
    
}

extension DRWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.showDefaultAlert(title: StringLiterals.WebView.error,
                                 message: StringLiterals.WebView.cantFindWebPage)
        }
        print("Failed to load URL: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.showDefaultAlert(title: StringLiterals.WebView.error,
                                 message: StringLiterals.WebView.cantFindWebPage)
        }
        print("Navigation error: \(error.localizedDescription)")
    }
    
}
