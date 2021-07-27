//
//  ViewController.swift
//  ACMVP
//
//  Created by AppCraft LLC on 8/27/21.
//

import UIKit
import ACExtensions

public protocol ViewInput: AnyObject {
    func setupInitialState(with model: Model)
    
    func beginLoading()
    func finishLoading(with error: Error?)
    
    func show(title: String?, message: String?, animated: Bool)
    func show(_ alertController: UIAlertController, animated: Bool)
}

public protocol ViewOutput: AnyObject {
    func viewIsReady(_ controller: UIViewController)
    
    func loadData()
    func reloadData()
    
    func goBack(animated: Bool)
    func close(animated: Bool)
}

open class ViewController: UIViewController, ViewInput {
    
    // MARK: - Props
    public var _output: ViewOutput?
    
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self._output?.viewIsReady(self)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - ViewInputProtocol
    open func setupInitialState(with model: Model) { }
    
    open func beginLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    open func finishLoading(with error: Error?) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if let error = error {
            self.show(title: "Error".localized,
                      message: error.localizedDescription,
                      animated: true)
        }
    }
    
    open func show(title: String?, message: String?, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "ОК".localized,
                                         style: .default,
                                         handler: nil)
            alertController.addAction(okAction)
            
            self?.present(alertController, animated: animated, completion: nil)
        }
    }
    
    open func show(_ alertController: UIAlertController, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: animated, completion: nil)
        }
    }
}
