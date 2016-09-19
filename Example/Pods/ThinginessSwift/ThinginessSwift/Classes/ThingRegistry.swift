//
//  ThingRegistry.swift
//  Pods
//
//  Created by Patrick Gleeson on 16/09/2016.
//
//

public class ThingRegistry {

    public static let sharedInstance = ThingRegistry()

    public func thingsOfType(type :String) -> ThingSet {
        return ThingSet(things: (registry[type] ?? []))
    }

    func register(thing: BaseThing, with_types types: Array<String>) {
        types.forEach { ( type : String) -> () in
            if var subregistry = registry[type] {
                subregistry.append(thing)
            } else {
                var subregistry = [thing]
                registry[type] = subregistry
            }
        }
    }
    
    private var registry = [String:Array<BaseThing>]()
}
