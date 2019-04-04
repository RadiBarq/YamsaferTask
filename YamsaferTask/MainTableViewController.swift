//
//  MainTableViewController.swift
//  YamsaferTask
//
//  Created by Radi Barq on 4/3/19.
//  Copyright © 2019 RadiBarq. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var discoverUrl = "https://api.themoviedb.org/3/discover/movie?api_key=bb086102499d3c4b2a86ab4d649ad6d7"
    var genreUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=7f8feac9c848bbf3ba5b99ebeac12f20&language=en-US"
    var imageUrl = "https://image.tmdb.org/t/p/w500"
    var data: MainData = MainData()
    var cellId = "cellId"

    @IBOutlet weak var ratingsStackView: UIStackView!

    @IBAction func donePressed(_ sender: UIButton) {
        
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
       // getData(type: .discover)
        getGenres()

    }
    

    func getData(type:SortingType, releaseYear: String = "")
    {
        var urlString = String()
        switch(type)
        {
            case .stars: urlString = discoverUrl + "&sort_by=Vote_average.desc"
            case .discover: urlString = discoverUrl
            case .releaseYear:
                urlString = discoverUrl + "&primary_release_year=" + releaseYear
            case .popularity: urlString = discoverUrl + "&sort_by​=Popularity.desc"
    
        }
        

        guard let url = URL(string: urlString) else
        {
            return
        }
    
        let urlRequest = URLRequest(url: url)
    
        data.clearData()
        self.callUrlSessionDataTask(url: urlRequest, dataType: .movies)
        
    }
    

    
    func getGenres()
    {
//        var genresCounter = 0
//        var tempDic = [Int: String]()
        
        guard let url = URL(string: genreUrl) else
        {
                return
        }
         let urlRequest = URLRequest(url: url)
            
         self.callUrlSessionDataTask(url: urlRequest, dataType: .genres)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
             self.title = "MovieDB"
             addBottomView()
    }
    
    func callUrlSessionDataTask(url: URLRequest, dataType:DataType)
    {
        
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            DispatchQueue.main.async {
                
                if (error == nil)
                {
                
                switch dataType
                {
                
                    case .genres: self.populateGenres(data: data, response: response, error: error)
                    
                    case .movies: self.popualteMovies(data: data, response: response, error: error)
                    
                }
                    
                }
                
                else
                {
                    print(error)
                }
                
             }
        }.resume()
    }
    

    func populateGenres(data: Data?, response: URLResponse?,error: Error?)
    {

        guard let data = data else {return}
        do {
            
          //  var genresCounter = 0
            var tempDic = [Int: String]()
            
            let decoder = JSONDecoder()
            let genres = try decoder.decode(Genres.self, from: data)
            
            for genre in genres.genres
            {
                tempDic[genre.id] = genre.name
            }
            
            //  tempDic[genre]
            //genresCounter = genresCounter + 1
            self.data.gernresNames = tempDic
            self.getData(type: .discover)
            
            //self.tableView.reloadData()
        }
            
        catch let jsonError {
            
            print("Failed to decode:", jsonError)
                }
            }

    
    func popualteMovies(data: Data?,response: URLResponse?,error: Error?)
    {
        
    
                guard let data = data else {return}
                
                do {
                    
                    var givenMovies = [Movie]()
                    let decoder = JSONDecoder()
                    let onePageMovie = try decoder.decode(Movies.self, from: data)
                    
                    for movie in onePageMovie.results
                    {
                        
                        givenMovies.append(movie)
                        var genreString = String()
                        
                        var backdropPath = movie.backdrop_path ?? " "
                        
                        var imageData = Data()
                        
                        if (backdropPath != " ")
                        {
                            let url = URL(string: self.imageUrl + backdropPath)
                            imageData = try! Data(contentsOf: url!)
                        }
                        
                        self.data.photosData[movie.id] = imageData
                        
                        for genreId in movie.genre_ids
                        {
                            genreString = genreString + self.data.gernresNames[genreId]! + ", "
                        }
                        
                        self.data.genres[movie.id] = genreString
                    }
                    
                    self.data.setMoviesArray(movies: givenMovies)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    
                }
                    
                catch let jsonError {
                    
                    print("Failed to decode:", jsonError)
                    
                }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.getMoviesArray().count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainTableViewCell
        var movie = data.getMoviesArray()[indexPath.row]

    
         cell.descriptionLabel.text = movie.overview
         cell.titleLabel.text = movie.title
         //let url = URL(string: imageUrl + movie.backdrop_path)
        //et imageData = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.movieImageView.image = UIImage(data: data.photosData[movie.id]!)
        
        var genreString = self.data.getGenresDic()[movie.id]!
        genreString =  String(genreString.dropLast())
        genreString =  String(genreString.dropLast())
        cell.genreLabel.text = genreString
        cell.setNumberOfStars(num: Int(movie.vote_average))
        
        

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EE, MMM d, yyyy"
    
        
        if let date = dateFormatterGet.date(from:  movie.release_date) {
            
            print(dateFormatterPrint.string(from: date))
            cell.dateLabel.text = dateFormatterPrint.string(from: date)
            cell.layer.masksToBounds = true
    
        } else {
            
            print("There was an error decoding the string")
        }
        
        return cell
      
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addBottomView()
    {
        
        let settingsButton = UIBarButtonItem(title: "Stars",
                                             style: .plain,
                                             target: self,
                                             action: #selector(onClickStars))
        
        let firstDevider = UIBarButtonItem(title: "|",
                                           style: .plain,
                                           target: self,
                                           action: nil)
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        
        firstDevider.tintColor = UIColor.gray
        
        
        let peace = UIBarButtonItem(title: "Popularity",
                                    style: .plain,
                                    target: self,
                                    action: #selector(onClickPopularity))
        
        // from the musical symbol block, not the misc symbol block
        let eighth = UIBarButtonItem(title: "Release Year",
                                     style: .plain,
                                     target: self,
                                     action: #selector(onClickRelaseYear))
        
        
        toolbarItems = [settingsButton ,flexibleSpace ,firstDevider, flexibleSpace,  peace, flexibleSpace, firstDevider, eighth]
        
        // or
        self.navigationController?.setToolbarItems(toolbarItems, animated: false)
        
    }
    
    
    @objc func onClickRelaseYear()
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "datePicker") as! DatePickerViewController
        vc.deleteDateDelegate = self
        
        vc.modalPresentationStyle  = .popover
  
        let popOverVC = vc.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.navigationController?.view
        popOverVC?.sourceRect = CGRect(x:200, y: 200, width: 0, height: 0)
        vc.preferredContentSize = CGSize(width: 300, height: 300)
        self.present(vc, animated: true)
    
    }
    
    @objc func onClickStars()
    {
    
        getData(type: .stars)
    
    }
    
    
    @objc func onClickPopularity()
    {
        
        getData(type: .popularity)
    }

}


extension MainTableViewController: ReleaseDateDelegate
{
    func releaseDateChange(newDate: String) {
        
        getData(type: .releaseYear,  releaseYear: newDate)
        
    }
}

extension MainTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


enum SortingType{
    
    case stars
    case discover
    case releaseYear
    case popularity

}


enum DataType{

    case movies
    case genres
    
}


