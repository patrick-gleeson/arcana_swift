//
//  ThingSetGenerator.swift
//  Pods
//
//  Created by Patrick Gleeson on 16/09/2016.
//
//

public struct ThingSetGenerator : GeneratorType {
    let things: Array<BaseThing>
    var indexInSequence: Int

    init(things: Array<BaseThing>) {
        self.things = things
        indexInSequence = 0
    }

    mutating public func next() -> BaseThing? {
        if indexInSequence >= things.count {
            return nil
        } else {
            var thing = things[indexInSequence]
            indexInSequence += 1
            return thing
        }
    }
}
