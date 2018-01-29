//
//  WebTestViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class WebTestViewController: UIViewController,UIWebViewDelegate {

    var context:JSContext?
    var jsContext: JSContext?
    var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.context?.evaluateScript("Swift_JS1()")
//        self.context?.evaluateScript("Swift_JS2('oc' ,'Swift')")
        
        webView = UIWebView()
    print(context ?? "")
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height)
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string:"http://blog.csdn.net/gaomingyangc/article/details/51686028")!))
        view.addSubview(webView)
         print(context ?? "")
        // Do any additional setup after loading the view.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
         print(context ?? "")
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
         print(context ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
