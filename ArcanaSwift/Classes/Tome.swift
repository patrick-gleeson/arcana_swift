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
        let wordEffect = typeWords[word]!.action
        return wordEffect()
    }

    public func invokeSelectorWord(word: String, onThingSet: ThingSet) -> ThingSet {
        let wordEffect = selectorWords[word]!.action
        return wordEffect(onThingSet)
    }

    public func invokeActionWord(word: String, onThingSet: ThingSet, withRefinements: [String: String]) {
        let wordEffect = actionWords[word]!.action
        wordEffect(onThingSet, withRefinements)
    }

    public func invokeRefinementWord(word: String) -> [String:String] {
        return refinementWords[word]!.action
    }

    public func registerWords() {
        preconditionFailure("You must override registerWords with assignments to typeWords, selectorWords, actionWords and refinementWords")
    }

    public func name()-> String {
        return String(Mirror(reflecting: self).subjectType)
    }

    public func definitions() -> [WordData] {
        var ret = [WordData]()
        typeWords.forEach { (key, tuple) in
            ret.append(WordData(category: .type, word: key, tome: self, description: tuple.description))
        }
        selectorWords.forEach { (key, tuple) in
            ret.append(WordData(category: .selector, word: key, tome: self, description: tuple.description))
        }
        actionWords.forEach { (key, tuple) in
            ret.append(WordData(category: .action, word: key, tome: self, description: tuple.description))
        }
        refinementWords.forEach { (key, tuple) in
            ret.append(WordData(category: .refinement, word: key, tome: self, description: tuple.description))
        }
        return ret
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

    public var typeWords: [String : (action:()->ThingSet, description: String)] = [:]
    public var selectorWords: [String : (action:(ThingSet)->ThingSet, description: String)] = [:]
    public var actionWords: [String : (action:(ThingSet, [String:String])->(), description: String)] = [:]
    public var refinementWords: [String : (action:[String: String], description: String)] = [:]

}