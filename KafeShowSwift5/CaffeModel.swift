//
//  CaffeModel.swift
//  KafeShowSwift5
//
//  Created by v on 03.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
   @objc dynamic var locatin: String?
   @objc dynamic var type: String?
    @objc dynamic var imageDate: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    convenience init(name: String, location: String?, type: String?, imageDate: Data?, rating: Double) {
        self.init()
        self.name = name
        self.locatin = location
        self.type = type
        self.imageDate = imageDate
        self.rating = rating
    }
    
    
    
}











//struct Cafes {
//    static let cafes = [
//        Cafe(name: "Burger Heroes", locatin: "Odessa", type: "restaurant", image: nil, restaurantImage: "Burger Heroes"),
//        Cafe(name: "Kitchen", locatin: "Odessa", type: "restaurant", image: nil, restaurantImage: "Kitchen"),
//        Cafe(name: "Bonsai", locatin: "London", type: "pizza", image: nil, restaurantImage: "Bonsai"),
//        Cafe(name: "Дастархан", locatin: "London", type: "cafe", image: nil, restaurantImage: "Дастархан"),
//        Cafe(name: "Индокитай", locatin: "Paris", type: "restourant", image: nil, restaurantImage: "Индокитай"),
//        Cafe(name: "Love&Life", locatin: "London", type: "pizza", image: nil, restaurantImage: "Love&Life"),
//        Cafe(name: "Бочка", locatin: "Rome", type: "cafe", image: nil, restaurantImage: "Бочка"),
//        Cafe(name: "Шок", locatin: "London", type: "pizza", image: nil, restaurantImage: "Шок"),
//        Cafe(name: "Классик", locatin: "London", type: "cafe", image: nil, restaurantImage: "Классик"),
//        Cafe(name: "Вкусные истории", locatin: "Moscow", type: "restourant", image: nil, restaurantImage: "Вкусные истории"),
//        Cafe(name: "Morris Pub", locatin: "London", type: "pizza", image: nil, restaurantImage: "Morris Pub"),
//        Cafe(name: "Speak Easy", locatin: "Kyiv", type: "pizza", image: nil, restaurantImage: "Speak Easy"),
//        Cafe(name: "Sherlock Holmes", locatin: "London", type: "cafe", image: nil, restaurantImage: "Sherlock Holmes"),
//        Cafe(name: "Балкан Гриль", locatin: "London", type: "pizza", image: nil, restaurantImage: "Балкан Гриль"),
//        Cafe(name: "X.O", locatin: "London", type: "restourant", image: nil, restaurantImage: "X.O")
//    ]
//}



