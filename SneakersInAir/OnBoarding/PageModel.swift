//
//  PageModel.swift
//  SneakersInAir
//
//  Created by Rodolfo Falanga on 20/02/24.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "Welcome to KIXS", description: "Ready?", imageUrl: "cowork", tag: 0),
        Page(name: "Scan Sneakers!", description: "kixs scans your shoes and provides information about them e.g. (price, materials, history)", imageUrl: "work", tag: 1),
        Page(name: "Know about your favorite drop!", description: "Don't like your shoes? Find new models and drops that are right for you", imageUrl: "website", tag: 2),
    ]
}
