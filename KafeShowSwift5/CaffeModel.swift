//
//  CaffeModel.swift
//  KafeShowSwift5
//
//  Created by v on 03.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import Foundation

struct Cafe {
    var name: String
    var locatin: String
    var type: String
    var image: String
    
}
struct Cafes {
    static let cafes = [
        Cafe(name: "Burger Heroes", locatin: "Odessa", type: "restaurant", image: "Burger Heroes"),
        Cafe(name: "Kitchen", locatin: "Odessa", type: "restaurant", image: "Kitchen"),
        Cafe(name: "Bonsai", locatin: "London", type: "pizza", image: "Bonsai"),
        Cafe(name: "Дастархан", locatin: "London", type: "cafe", image: "Дастархан"),
        Cafe(name: "Индокитай", locatin: "Paris", type: "restourant", image: "Индокитай"),
        Cafe(name: "Love&Life", locatin: "London", type: "pizza", image: "Love&Life"),
        Cafe(name: "Бочка", locatin: "Rome", type: "cafe", image: "Бочка"),
        Cafe(name: "Шок", locatin: "London", type: "pizza", image: "Шок"),
        Cafe(name: "Классик", locatin: "London", type: "cafe", image: "Классик"),
        Cafe(name: "Вкусные истории", locatin: "Moscow", type: "restourant", image: "Вкусные истории"),
        Cafe(name: "Morris Pub", locatin: "London", type: "pizza", image: "Morris Pub"),
        Cafe(name: "Speak Easy", locatin: "Kyiv", type: "pizza", image: "Speak Easy"),
        Cafe(name: "Sherlock Holmes", locatin: "London", type: "cafe", image: "Sherlock Holmes"),
        Cafe(name: "Балкан Гриль", locatin: "London", type: "pizza", image: "Балкан Гриль"),
        Cafe(name: "X.O", locatin: "London", type: "restourant", image: "X.O")
    ]
}



