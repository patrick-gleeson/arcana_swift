//
//  Tome.swift
//  Pods
//
//  Created by Patrick Gleeson on 19/09/2016.
//
//

import ThinginessSwift

public class Tome  {
    public init() {
        registerWords()
    }

    public func invokeTypeWord(word: String) -> ThingSet {
        let wordEffect = typeWords[word]
        return wordEffect!()
    }

    public func invokeSelectorWord(word: String, onThingSet: ThingSet) -> ThingSet {
        let wordEffect = selectorWords[word]
        return wordEffect!(onThingSet)
    }

    public func invokeActionWord(word: String, onThingSet: ThingSet, withRefinements: [String: String]) {
        let wordEffect = actionWords[word]
        wordEffect!(onThingSet, withRefinements)
    }

    public func invokeRefinementWord(word: String) -> [String:String] {
        return refinementWords[word]!
    }

    public func registerWords() {
        preconditionFailure("You must override registerWords with assignments to typeWords, selectorWords, actionWords and refinementWords")
    }

    public func getCategoryOf(word: String) -> WordCategory? {
        if  typeWords[word] != nil {
            return WordCategory.type
        } else if selectorWords[word] != nil {
            return WordCategory.selector
        } else if actionWords[word] != nil {
            return WordCategory.action
        } else if refinementWords[word] != nil {
            return WordCategory.refinement
        } else {
            return nil
        }
    }

    public var typeWords: [String : ()->ThingSet] = [:]
    public var selectorWords: [String : (ThingSet)->ThingSet] = [:]
    public var actionWords: [String : (ThingSet, [String:String])->()] = [:]
    public var refinementWords: [String : [String: String]] = [:]

}