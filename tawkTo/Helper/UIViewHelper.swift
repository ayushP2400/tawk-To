//
//  UIViewHelper.swift
//  tawkTo
//
//  Created by love on 15/03/21.
//

import Foundation
import UIKit

extension UIView{
    func setCornerRadius(_ val: CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = val
    }
    func setBorder(with val: CGFloat, color: UIColor){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = val
    }
}
extension UIImage {
    func invertedImage() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let ciImage = CoreImage.CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let context = CIContext(options: nil)
        guard let outputImage = filter.outputImage else { return nil }
        guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: outputImageCopy, scale: self.scale, orientation: .up)
    }
}
extension UITableView{
    static var activityIndicatorView = UIActivityIndicatorView()

    func indicatorView() -> UIActivityIndicatorView{
        if self.tableFooterView == nil{
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            UITableView.activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            UITableView.activityIndicatorView.isHidden = false
            self.tableFooterView = UITableView.activityIndicatorView
            return UITableView.activityIndicatorView
        }else{
            return UITableView.activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().isHidden = false
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print(self.indicatorView())
                    closure()
                }
            }
        }
    }
    
    func stopLoading(){
        indicatorView().stopAnimating()
        indicatorView().isHidden = true
    }
}
extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(greaterThanOrEqualTo: guide.topAnchor, constant: +(16)),
            toastLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            toastLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            toastLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -(16))
        ])
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
