//
//  Word.swift
//  Pods
//
//  Created by Patrick Gleeson on 20/09/2016.
//
//

public struct WordData {
    public init(category: WordCategory, word: String, tome: Tome) {
        self.init(category: category, word: word, tome: tome, description: nil)
    }

    public init(category: WordCategory, word: String, tome: Tome, description: String?) {
        self.category = category
        self.word = word
        self.tome = tome
        self.description = description
    }


    public var category: WordCategory
    public var word: String
    public var tome: Tome
    public var description: String? = nil
}
