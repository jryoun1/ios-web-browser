//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlEnteredTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    
    var currentUrlListArray: [URL] = []
    
    //문제 1. 잘못된 형식url을 배열에 넣어줄때도 https://를 붙여주어야되고
    //문제 2. 입력을 통한 이동이 아닌 콘텐츠를 터치해서 눌렀을 경우는 currentUrlListArray에 추가되지 않음
    //    >> convertStringToUrl속에서 currentUrlListArray.append() 해서 해결
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaultUrl: String = "https://www.github.com"
        webView?.navigationDelegate = self
        loadWebPageToWebView(to: defaultUrl)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error){
        showAlert(message: "입력하신 URL이 유효하지 않습니다.")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("^^^^^^^^^^    \(currentUrlListArray)     ^^^^^^^^^")
    }
    
    func convertStringToUrl(input string: String?) -> URL? {
        guard let urlString = string else {
            showAlert(message: "입력 URL이 없어서 종료됩니다.")
            return nil
        }
        if isUrlStringValid(needCheck: urlString) {
            let convertedUrl: URL? = URL(string: urlString)
            return convertedUrl
        }
        else {
            let changedUrl: String = autoChangeUrl(notValidUrl: urlString)
            let convertedUrl: URL? = URL(string: changedUrl)
            return convertedUrl
        }
    }
    
    func autoChangeUrl(notValidUrl: String) -> String {
        let httpAddUrl: String = "https://" + notValidUrl
        return httpAddUrl
    }
    
    private func loadWebPageToWebView(to string: String?) {
        guard let requestedURL = convertStringToUrl(input: string) else {
            showAlert(message: "변환할 URL이 존재하지 않습니다.")
            return
        }
        currentUrlListArray.append(requestedURL)
        let request = URLRequest(url: requestedURL)
        webView.load(request)
        checkButtonState()
    }

    func isUrlStringValid(needCheck notCheckedUrl: String) -> Bool {
        let checkedUrl = notCheckedUrl.lowercased()
        if checkedUrl.hasPrefix("http://") || checkedUrl.hasPrefix("https://") {
            return true
        }
        return false
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToEnteredURL(_ sender: UIButton) {
        guard let enteredURL = urlEnteredTextField?.text else {
            showAlert(message: "주소창에 입력된 주소가 없습니다.")
            return
        }
        loadWebPageToWebView(to: enteredURL)
    }
    
    func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
//        print(self.webView.backForwardList.backItem as Any)
//        print(self.webView.backForwardList.currentItem?.url as Any)
//        print(self.webView.backForwardList.forwardItem as Any)
    }
    
    func checkButtonState() {
        if currentUrlListArray.count == 1 {
            goBackButton.isEnabled = false
        } else {
            goBackButton.isEnabled = true
        }
    }
    
    @IBAction func goBackCustomize(_ sender: UIBarButtonItem) {
        if currentUrlListArray.count != 0 {
            currentUrlListArray.removeLast()
            guard let backUrl = self.currentUrlListArray.last else { return }
            //이미 검증되고, 잘못된경우 https://가 붙어서 들어왔으니 loadWebPageToWebView로 안불러도 될듯
            let request = URLRequest(url: backUrl)
            webView.load(request)
            checkButtonState()
        }
    }
    
    @IBAction func reloadCustomize(_ sender: UIBarButtonItem) {
        guard let currentUrl = self.webView.backForwardList.currentItem?.url else { return }
        let currentStringUrl: String = String(describing: currentUrl)
        loadWebPageToWebView(to: currentStringUrl)
    }
    
//    @IBAction func goBack(_ sender: UIBarButtonItem) {
//        if webView.canGoBack {
//            webView.goBack()
//        }
//    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}
