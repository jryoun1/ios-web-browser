//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favoriteURL: URL? = URL(string: "https://www.github.com")
        loadWebPageToWebView(url: favoriteURL)
        
    }
    
    /*
    우리조가 즐켜찾는 웹페이지 URL로 웹뷰를 로드시켜주는 함수
    code by jake,zziro
    */
    func loadWebPageToWebView(url: URL?) {
        guard let URL = url else { print("URL주소가 없어서 종료됩니다."); return }
        let myRequest = URLRequest(url: URL)
        webView.load(myRequest)
    }
    
    
    @IBAction func touchUpGoButton(_ sender: UIButton) {
        guard let InputURL = urlTextField.text, let newURL: URL = URL(string: InputURL) else { print("입력값이 없거나 잘못되었습니다 ."); return }
        print("---\(InputURL)---")
        
        loadWebPageToWebView(url: newURL)
    }
    
    @IBAction func touchUpGoBackButton(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func touchUpGoForwardButton(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction func touchUpReloadButton(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
}
