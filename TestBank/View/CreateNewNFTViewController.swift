//
//  CreateNewNFTViewController.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import UIKit
import PhotosUI


class CreateNewNFTViewController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var sellingPriceTF: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var uploadImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.descriptionTextView.layer.cornerRadius = 12
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionTextView.addDoneButtonOnKeyboard()
        
        self.titleTF.layer.cornerRadius = 12
        self.titleTF.layer.borderWidth = 1
        self.titleTF.layer.borderColor = UIColor.lightGray.cgColor
        self.titleTF.addDoneButtonOnKeyboard()
        
        self.sellingPriceTF.layer.cornerRadius = 12
        self.sellingPriceTF.layer.borderWidth = 1
        self.sellingPriceTF.layer.borderColor = UIColor.lightGray.cgColor
        self.sellingPriceTF.addDoneButtonOnKeyboard()
    }
    
    func openGallery() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    func successPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SuccessPageUploadViewController") as? SuccessPageUploadViewController {
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    @IBAction func createNftBtnAction(_ sender: UIButton) {
        
        if titleTF.text == "" {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!",
                                              message: "please enter title!",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil))

                self.present(alert, animated: true)
            }
        } else if sellingPriceTF.text == "" {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!",
                                              message: "please enter Selling Price!",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil))

                self.present(alert, animated: true)
            }
        } else {
            APIService.shared.uploadNFT(path: "/v2/beetobeeNftUpload",
                                        image: uploadImgView.image ?? UIImage(),
                                        title: titleTF.text ?? "",
                                        description: descriptionTextView.text ?? "",
                                        sellingPrice: sellingPriceTF.text ?? "") {
                (result : Result<NFTcreatNewModel,Error>) in
                
                switch result{
                case.success(let data):
                    print(data)
                    DispatchQueue.main.async {
                        self.successPage()
                    }
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
    
   
    @IBAction func uploadPhotoBtnAction(_ sender: UIButton) {
        openGallery()
    }
    
}
extension CreateNewNFTViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }

        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.uploadImgView.image = image as? UIImage
                }
            }
        }
    }
}

extension CreateNewNFTViewController: SuccessPageUploadViewControllerprotocol {
    func didAddedNewCard() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
