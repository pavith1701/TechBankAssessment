//
//  LandingPageViewController.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    var landPageList: [ProductListResponse] = []
    var myNFTList: [MyNFTListDataModel] = []
    var myCoinsList: [CoinListDataModel] = []
    var selectedSegmentVal:String = "MYNFT"
    var isMyWallet: Bool = false
    var imgItemFromIndex: String?
    var itemNameFromIndex: String?
    var itemPriceFromIndex: String?
    var itemTypeFromIndex: String?
    var itemDescriptionFromIndex: String?
    
    
    @IBOutlet weak var myCoinTableView: UITableView!
    @IBOutlet weak var landingPageCollectionView: UICollectionView!
    @IBOutlet weak var landingImgbackgoundView: UIImageView!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var myWalletTblView: UIView!
    @IBOutlet weak var secondryView: UIView!
    @IBOutlet weak var createNFTview: UIView!
    
    
    @IBOutlet weak var segmentIndex: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.landingImgbackgoundView.layer.cornerRadius = 12
        self.secondryView.layer.cornerRadius = 30
        segmentIndex.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segmentIndex.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.myWalletTblView.isHidden = true
        self.segmentIndex.isHidden = true
        self.createNFTview.isHidden = true
        self.collectionViewTopConstraint.constant = -48
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        fetchList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToPurchasePage" {
            let vc = segue.destination as! PurchasePageViewController
            vc.imgURL = self.imgItemFromIndex
            vc.itemName = itemNameFromIndex
            vc.itemPrice = itemPriceFromIndex
            vc.itemDescription = itemDescriptionFromIndex
            vc.itemType = itemTypeFromIndex
        }
    }
    
    @IBAction func segmentIndexAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.isMyWallet = false
            self.segmentIndex.isHidden = true
            self.createNFTview.isHidden = true
            self.myWalletTblView.isHidden = true
            self.collectionViewTopConstraint.constant = -48
            self.landingPageCollectionView.isHidden = false
            fetchList()
        case 1:
            self.isMyWallet = true
            if selectedSegmentVal == "MYNFT" {
                self.segmentIndex.isHidden = false
                self.createNFTview.isHidden = false
                self.myWalletTblView.isHidden = true
                self.collectionViewTopConstraint.constant = 12
                self.landingPageCollectionView.isHidden = false
                self.getMyNfts()
            } else if selectedSegmentVal == "COINS" {
                self.segmentIndex.isHidden = false
                self.createNFTview.isHidden = false
                self.collectionViewTopConstraint.constant = 12
                self.landingPageCollectionView.isHidden = true
                self.myWalletTblView.isHidden = false
            }
            
        default:
            return
        }
    }
    
    @IBAction func segmentMYnftCoinActon(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedSegmentVal = "MYNFT"
            self.myWalletTblView.isHidden = true
            self.landingPageCollectionView.isHidden = false
            self.getMyNfts()
        case 1:
            self.selectedSegmentVal = "COINS"
            self.myWalletTblView.isHidden = false
            self.landingPageCollectionView.isHidden = true
            getMyCoins()
        default:
            return
        }
    }
    
    @IBAction func creatNFTBtnAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "navToCreateNFT", sender: self)
    }
    
    func fetchList() {
        
        APIService.shared.getRequest(path: "/v2/beetobeeGetProducts") { (result: Result<ProductListResponseWrapper, Error>) in
            switch result {
            case .success(let data):
                //print("Products:", data.items)
                self.landPageList = data.items
                self.landingPageCollectionView.reloadData()
            case .failure(let error):
                print("Error:", error)
            }
            
        }
    }
    func getMyNfts() {
        
        APIService.shared.getRequest(path: "/v2/beetobeeMyNfts?userid=user-001&email=jane.cooper@example.com") { (result: Result<MyNFTListModel, Error>) in
            switch result {
            case .success(let data):
                //print("NFT List:", data.items)
                self.myNFTList = data.items
                self.landingPageCollectionView.reloadData()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
    func getMyCoins() {
        
        APIService.shared.getRequest(path: "/v2/beetobeeMywalletBalance?userid=user-001&email=jane.cooper@example.com") { (result: Result<CoinListModel, Error>) in
            switch result {
            case .success(let data):
                print("NFT List:", data.coins)
                self.myCoinsList = data.coins
                self.myCoinTableView.reloadData()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
    
}
extension LandingPageViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedSegmentVal == "MYNFT" && isMyWallet {
            return myNFTList.count
        } else {
            return landPageList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageCollectionViewCell", for: indexPath) as! LandingPageCollectionViewCell
        
        if selectedSegmentVal == "MYNFT" && isMyWallet {
            if let imgUrl = myNFTList[indexPath.row].imageUrl {
                let w = cell.imgCard.bounds.width
                let h = cell.imgCard.bounds.height
                DispatchQueue.main.async {
                    cell.imgCard.loadImage(from: imgUrl, targetSize: CGSize(width: w, height: h))
                }
                
            }
            cell.cardName.text = myNFTList[indexPath.row].title
            let price:Double = myNFTList[indexPath.row].price ?? 0.0
            let pricecurrency = String(price) + " " + (myNFTList[indexPath.row].currency ?? "")
            cell.cardPrize.text = pricecurrency
            return cell
        } else {
            
            if let imgUrl = landPageList[indexPath.row].imageUrl {
                let w = cell.imgCard.bounds.width
                let h = cell.imgCard.bounds.height
                DispatchQueue.main.async {
                    cell.imgCard.loadImage(from: imgUrl, targetSize: CGSize(width: w, height: h))
                }
                
            }
            cell.cardName.text = landPageList[indexPath.row].title
            let price:Double = landPageList[indexPath.row].price ?? 0.0
            let pricecurrency = String(price) + " " + (landPageList[indexPath.row].currency ?? "")
            cell.cardPrize.text = pricecurrency
            return cell
        }
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedSegmentVal == "MYNFT" && isMyWallet {
            
            self.imgItemFromIndex = myNFTList[indexPath.row].imageUrl
            self.itemNameFromIndex = myNFTList[indexPath.row].title
            self.itemTypeFromIndex = myNFTList[indexPath.row].id
            self.itemDescriptionFromIndex = myNFTList[indexPath.row].description
            let price:Double = myNFTList[indexPath.row].price ?? 0.0
            let pricecurrency = String(price) + " " + (myNFTList[indexPath.row].currency ?? "")
            self.itemPriceFromIndex = pricecurrency
            self.performSegue(withIdentifier: "navToPurchasePage", sender: self)
        } else {
            self.imgItemFromIndex = landPageList[indexPath.row].imageUrl
            self.itemNameFromIndex = landPageList[indexPath.row].title
            self.itemTypeFromIndex = landPageList[indexPath.row].id
            self.itemDescriptionFromIndex = landPageList[indexPath.row].description
            let price:Double = landPageList[indexPath.row].price ?? 0.0
            let pricecurrency = String(price) + " " + (landPageList[indexPath.row].currency ?? "")
            self.itemPriceFromIndex = pricecurrency
            self.performSegue(withIdentifier: "navToPurchasePage", sender: self)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 3
        
        let width = (collectionView.frame.width - totalSpacing) / 2
        
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    
}
extension LandingPageViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCoinsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyWalletPageTableViewCell", for: indexPath) as! MyWalletPageTableViewCell
        cell.coinNameLabel.text = myCoinsList[indexPath.row].symbol
        let coinValue: Double = (myCoinsList[indexPath.row].balance ?? 0.0)
        let coinValueStr:String = String(coinValue) + " " + (myCoinsList[indexPath.row].symbol ?? "")
        cell.coinValLabel.text = coinValueStr
        
        if myCoinsList[indexPath.row].symbol?.lowercased() == "bnb" {
            cell.cardImg.image = UIImage(named: "Bnb3XLogo")
        }
        if myCoinsList[indexPath.row].symbol?.lowercased() == "eth" {
            cell.cardImg.image = UIImage(named: "eth3xLogo")
        }
        if myCoinsList[indexPath.row].symbol?.lowercased() == "btc" {
            cell.cardImg.image = UIImage(named: "btc3xlogo")
        }
        if myCoinsList[indexPath.row].symbol?.lowercased() == "usdt" {
            cell.cardImg.image = UIImage(named: "usdt3xlogo")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
