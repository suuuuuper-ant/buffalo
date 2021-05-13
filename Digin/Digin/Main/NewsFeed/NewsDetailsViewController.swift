//
//  NewsDetailsViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/04/20.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    private var estimatedProgressObserver: NSKeyValueObservation?

    var newsURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        setupEstimatedProgressObserver()

        if let url = URL(string: newsURL) {
            // - 캐시 기본 정책 사용, 타임아웃은 10초로 지정하였습니다.
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
            webView.navigationDelegate = self
            webView.load(request)
        } else {
            //TODO: 예외처리
        }

        urlLabel.text = newsURL
    }

    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in

            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }

    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - WKNavigationDelegate
///reference: https://gist.github.com/fxm90/723b5def31b46035cd92a641e3b184f6
extension NewsDetailsViewController: WKNavigationDelegate {

    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {

        if progressView.isHidden {
            progressView.isHidden = false
        }

        UIView.animate(withDuration: 0.33, animations: {
            self.progressView.alpha = 1.0
        })
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33, animations: {
            self.progressView.alpha = 0.0

        }, completion: { isFinished in
            self.progressView.isHidden = isFinished
        })
    }

}
