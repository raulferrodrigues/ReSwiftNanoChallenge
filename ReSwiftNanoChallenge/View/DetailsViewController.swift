//
//  DetailsViewController.swift
//  ReSwiftNanoChallenge
//
//  Created by Raul Rodrigues on 8/19/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit
import ReSwift

class DetailsViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    
    var movie: Result?
    var poster: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else { fatalError("Movie not set") }
        guard let poster = poster else { fatalError("Poster not set") }
        
        moviePoster.image = poster
        movieTitle.text = movie.title
        
        guard let voteAvarage = movie.voteAverage else { return }
        movieRating.text = "\(voteAvarage)"
        movieOverview.text = movie.overview
        
        
        guard let genres = movie.genreIDS else { return }
        DispatchQueue.main.async { [weak self, genres] in
            Network.genres(ids: genres) { dictionary in
                if genres.count > 0 {
                    let firstGenre = dictionary[genres[0]]
                    var str = "\(firstGenre ?? "Erro")"
                    for n in 1 ..< genres.count {
                        str += ", \(dictionary[genres[n]] ?? "Erro")"
                    }
                    self?.movieGenre.text = str
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
