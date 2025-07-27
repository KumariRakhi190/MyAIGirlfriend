//
//  ViewPictureViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 21/07/23.
//

import UIKit
import Mixpanel

class ViewPictureViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activitySourceView: UIView!
    
    var image: UIImage?
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func initialSetup(){
        imageView.image = image
        scrollView.maximumZoomScale = 10
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    @IBAction func didTapDownload(_ sender: Any) {
        guard let image else {return}
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = activitySourceView
        self.present(activityViewController, animated: true)
        Mixpanel.mainInstance().track(event: "Save picture", properties: ["premade character": !(1...1000 ~= character?.id ?? 0)])

    }
    
    @IBAction func didTapClose(_ sender: Any) {
        pop()
    }
}

extension ViewPictureViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
}
