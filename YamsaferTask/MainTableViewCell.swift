//
//  MainTableViewCell.swift
//  YamsaferTask
//
//  Created by Radi Barq on 4/3/19.
//  Copyright © 2019 RadiBarq. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    //@IBOutlet weak var ratingCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    private var numberOfStars = 0
    
    public var ratingsStackView = UIStackView()

    
    public var dateLabel: UILabel = {
        
        var label = UILabel()
        label.text = "Tue, Oct 20, 2015"
        label.textColor = UIColor.init(red: 39/255, green: 70/255, blue: 117/255, alpha: 1)
        label.font = UIFont(name: "Avenir-Heavy", size: 12)!
        label.textAlignment = .center
        return label
        
    }()
    
    
    var cellId = "cellId"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
      //  self.ratingCollectionView.delegate = self
      //  self.ratingCollectionView.dataSource = self
        //self.ratingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        initializeStackView()
        initialzieimage()
        addBorder()
        // Initialization code
    }
    
    
    func initializeStackView()
    {
        self.addSubview(ratingsStackView)
        ratingsStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        ratingsStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        //ratingsStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        ratingsStackView.bottomAnchor.constraint(equalTo: genreLabel.topAnchor,constant: -7.5).isActive = true
        ratingsStackView.axis = .horizontal
      //  ratingsStackView.heightAnchor.constraint(equalToConstant:  10).isActive = true
        ratingsStackView.alignment = .center
        ratingsStackView.distribution = .fill
        ratingsStackView.spacing = 2
        
    }
    
    
    
    func initialzieimage()
    {
    
        var view = UIView()
        self.movieImageView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: movieImageView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: movieImageView.rightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.centerXAnchor.constraint(equalTo: self.movieImageView.centerXAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.movieImageView.bottomAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
    }

    func addBorder()
    {
        var view = UIView()
        self.backgroundView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    
        
     //   view.backgroundColor = UIColor.gray
        
        let yourColor : UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//        let yourColor : UIColor = UIColor.gray
        view.layer.masksToBounds = true
        view.layer.borderColor = yourColor.cgColor
        view.layer.borderWidth = 1.0
        //view.backgroundColor = UIColor.gray
    }
    
    
    func setNumberOfStars(num: Int)
    {
        numberOfStars = num
    
        for view in ratingsStackView.subviews
        {
            view.removeFromSuperview()
        }
        
        for i in 0..<numberOfStars
        {
            
            let imageView = UIImageView(image: UIImage(named: "star"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 11).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
            ratingsStackView.addArrangedSubview(imageView)
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


//extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return numberOfStars
//
//    }
//
//
//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    return CGSize(width: 10, height: 10)
//}
//
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UICollectionViewCell
//        let imageView: UIImageView = UIImageView(image: UIImage(named: "star"))
//
//        imageView.frame = cell.contentView.bounds
//        cell.contentView.addSubview(imageView)
//
//
//        return cell
//
//    }
//
//
//
//}

