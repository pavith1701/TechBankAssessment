//
//  SuccessPageUploadViewController.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import UIKit

protocol SuccessPageUploadViewControllerprotocol: AnyObject {
    
    func didAddedNewCard()
}

class SuccessPageUploadViewController: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    var delegate: SuccessPageUploadViewControllerprotocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.layer.cornerRadius = 28
       
    }
    
    @IBAction func viewNFTBtnAction(_ sender: UIButton) {
        self.delegate?.didAddedNewCard()
        self.dismiss(animated: true)
    }
    
    
}
