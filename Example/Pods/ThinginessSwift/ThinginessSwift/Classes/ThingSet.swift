//
//  ThingSet.swift
//  Pods
//
//  Created by Patrick Gleeson on 16/09/2016.
//
//

public class ThingSet : SequenceType {
    public init(things: Array<BaseThing>) {
        self.things = things
    }

    public func generate() -> ThingSetGenerator {
        return ThingSetGenerator(things: things)
    }

    public func matching(attributes: [String: String]) -> ThingSet {
        let matching_things = things.filter { (thing: BaseThing) in
            var matches = true
            attributes.forEach { (name: String, value: String) in
                if thing.attribute(name) != value {
                    matches = false
                }
            }
            return matches
        }
        return ThingSet(things: matching_things)
    }

    public func updateAll(attributes: [String: String]) {
        things.forEach { (thing) in
            thing.update(attributes)
        }
    }

    public var count: Int {
        return things.count
    }

    private var things: Array<BaseThing>
}
