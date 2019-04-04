//
//  MainData.swift
//  YamsaferTask
//
//  Created by Radi Barq on 4/3/19.
//  Copyright © 2019 RadiBarq. All rights reserved.
//

import Foundation

class MainData {
    
    var movies = [Movie]()
    var genres = [Int: String]()
    public var photosData = [Int: Data]()
    var gernresNames =  [Int: String]()
    

    func getMoviesArray() -> [Movie]
    {
        return movies
    }
    
    func clearData()
    {
        
        movies = [Movie]()
        genres = [Int: String]()
        photosData = [Int: Data]()
        
    }
    
    func getGenresDic() -> [Int: String]
    {
        return genres
    }
    
    
    func setMoviesArray(movies: [Movie])
    {
        self.movies = movies
        
    }
    
    func setGenreDic(genres: [Int:String])
    {
        self.genres = genres
    }
    
}




struct Movies:Decodable{
    
    public var results = [Movie]()
    
}

struct Movie:Decodable{
    
    var vote_count: Double
    var id: Int
    var video: Bool
    var vote_average: Double
    var title:String
    var popularity:Double
    var poster_path: String?
    var original_language: String
    var original_title:String
    var genre_ids: [Int]
    var backdrop_path: String?
    var adult: Bool
    var overview:String
    var release_date:String
    
}

struct Genres:Decodable{
    
    var genres: [Genre]
    
}


struct Genre:Decodable{
    
    var id:Int
    var name:String
    
}
