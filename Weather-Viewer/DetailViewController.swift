//
//  DetailViewController.swift
//  Weather-Viewer
//
//  Created by Rey Jairus Marasigan on 9/18/21.
//

import UIKit

class DetailViewController: UIViewController {
    //@IBOutlet= connects to imageboard
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber: Int?
    var totalPictures: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //both are optionals
        title = "Picture \(selectedPictureNumber!) of \(totalPictures!)"
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}

