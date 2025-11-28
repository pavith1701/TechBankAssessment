//
//  BuyNFTPageViewController.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import UIKit


protocol BuyNFTPageViewControllerprotocol: AnyObject {
    func didBuyNFT()
}

class BuyNFTPageViewController: UIViewController {
    
    
    var cardImgUrl: String?
    var itemName: String?
    var itemTyp: String?
    var buyPrice: String?
    var delegate: BuyNFTPageViewControllerprotocol?
    
    @IBOutlet weak var pagePaymentDtlsView: UIView!
    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemTypLabel: UILabel!
    @IBOutlet weak var buyPriceLabel: UILabel!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    @IBOutlet weak var successPage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pagePaymentDtlsView.layer.cornerRadius = 30
        let w = cardImgView.bounds.width
        let h = cardImgView.bounds.height
        
        self.cardImgView.loadImage(from: cardImgUrl ?? "", targetSize: CGSize(width: w, height: h))
        self.itemTypLabel.text = itemTyp
        self.itemNameLabel.text = itemName
        self.buyPriceLabel.text = buyPrice
        self.successPage.isHidden = true
    }
    

    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buyNFTBtnAction(_ sender: UIButton) {
        self.byNFT(nftID: itemTyp) //itemTyp: NFTid
    }
    
    @IBAction func closeAfterSuccessBuyAction(_ sender: UIButton) {
        self.delegate?.didBuyNFT()
        self.dismiss(animated: true)
    }
    
    func byNFT(nftID: String?) {
        
        let payLoad: [String:Any] = [
            "email" : "jane.cooper@example.com",
            "userid": "user-001",
            "nft_id": nftID ?? ""
        ]
        
        APIService.shared.postRequest(path: "/v2/beetobeeBuyNft", body: payLoad) {
            (result : Result<NFTcreatNewModel,Error>) in
            switch result{
            case.success(let data):
                print(data)
                self.successPage.isHidden = false
            case.failure(let error):
                
                let errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert!",
                                                  message: errorMessage,
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .default,
                                                  handler: nil))

                    self.present(alert, animated: true)
                }
                print(error)
            }
        }
        
    }
    
}
