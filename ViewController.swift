//
//  ViewController.swift
//  ReSwiftNanoChallenge
//
//  Created by Raul Rodrigues on 8/14/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var cache = NSCache<NSString, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ok")
        
        Network.nowPlaying() { result, error in
            if let error = error {
                print("error")
                return
            }

            guard let result = result else { return }
            
            if let imageObject = self.cache.object(forKey: "/keym7MPn1icW1wWfzMnW3HeuzWU.jpg") {
                self.imageView.image = imageObject as? UIImage
            } else {
                Network.moviePoster(imagePath: result[0].posterPath!, completionHandler: { (data, path) in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        guard let data = data else { return }
                        guard let path = path else { return }
                        
                        let image = UIImage(data: data)
                        self.imageView.image = image
                        self.cache.setObject(image!, forKey: NSString(string: path))
                    }
                })
            }
            
            
            
            for movie in result {
                print("\(movie.posterPath!)")
                Network.movieDetails(id: movie.id!, completionHandler: { details, error in
                    if let error = error {
                        print("error")
                        return
                    }
                    
                    guard let details = details else { return }
                    
                    print("\n\(details.originalTitle!)")
                    for genre in details.genres! {
                        print(genre.name!)
                    }
                })
            }
        }
    }


}

