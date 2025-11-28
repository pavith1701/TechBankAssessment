//
//  PurchasePageViewController.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//

import UIKit

class PurchasePageViewController: UIViewController {
    
    var myCoinsList: [CoinListDataModel] = []
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var imgURL: String?
    var itemName: String?
    var itemPrice: String?
    var itemType: String?
    var itemDescription: String?
    
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var itemPrizeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.imageItem.layer.cornerRadius = 23
        let w = imageItem.bounds.width
        let h = imageItem.bounds.height
        self.imageItem.loadImage(from: imgURL ?? "", targetSize: CGSize(width: w, height: h))
        
        self.itemPrizeLabel.text = itemPrice
        self.itemNameLabel.text = itemName
        self.itemTypeLabel.text = itemType
        self.descriptionTextView.text = itemDescription
        self.descriptionTextView.isEditable = false
        getWalletBal()
    }
    

    @IBAction func buyNftBtnAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "byNFTPageViewController") as? BuyNFTPageViewController {
            
            vc.buyPrice = itemPrice
            vc.cardImgUrl = imgURL
            vc.itemName = itemName
            vc.itemTyp = itemType
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    func getWalletBal() {
        
        APIService.shared.getRequest(path: "/v2/beetobeeMywalletBalance?userid=user-001&email=jane.cooper@example.com") { (result: Result<CoinListModel, Error>) in
            switch result {
            case .success(let data):
                print("NFT List:", data.coins)
                self.myCoinsList = data.coins
                self.appdelegate.myWalletBalance = self.myCoinsList[3].balance
                print(self.appdelegate.myWalletBalance)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
}
extension PurchasePageViewController: BuyNFTPageViewControllerprotocol {
    func didBuyNFT() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
