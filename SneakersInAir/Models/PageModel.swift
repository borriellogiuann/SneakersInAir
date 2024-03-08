//
//  PageModel.swift
//  SneakersInAir
//
//  Created by Salvo on 06/03/24.
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
        Page(name: "Welcome to KIXS", description: "The best app to scan sneakers and identify them.", imageUrl: "first", tag: 0),
        Page(name: "Scan Sneakers", description: "Thanks to our scanning technology, you can identify sneakers with a simple tap!", imageUrl: "second", tag: 1),
        Page(name: "Try our Website!", description: "You have no Sneakers to scan? Try our website!", imageUrl: "third", tag: 2),
    ]
}
