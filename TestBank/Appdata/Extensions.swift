//
//  Extensions.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//


import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImage(from urlString: String, targetSize: CGSize? = nil) {
        self.image = nil   // reset before reuse

        // Check cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {

                // Resize image if needed
                let finalImage: UIImage
                if let size = targetSize {
                    finalImage = image.resized(to: size)
                } else {
                    finalImage = image
                }

                // Cache resized image
                imageCache.setObject(finalImage, forKey: urlString as NSString)

                DispatchQueue.main.async {
                    self.image = finalImage
                }
            }
        }.resume()
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UITextField {

    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .prominent,
            target: self,
            action: #selector(doneButtonTapped)
        )

        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
}
extension UITextView {

    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .prominent,
            target: self,
            action: #selector(doneButtonTapped)
        )

        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
}
