//
//  BaseThing.swift
//  Pods
//
//  Created by Patrick Gleeson on 16/09/2016.
//
//

public class BaseThing {
    // Constructors
    public init(attributes: [String: String]) {
        self.attributes = attributes ?? [String:String]()

        ThingRegistry.sharedInstance.register(self, with_types: thingTypes())
    }

    public convenience init() {
        self.init(attributes: [:])
    }

    // Public methods
    public func attribute(attribute_name: String) -> String? {
        return attributes[attribute_name]
    }

    public func update(newAttributes: [String: String]) {
        newAttributes.forEach { (name : String, value: String) -> () in
            attributes[name] = value
        }
    }

    // Private methods
    private func thingTypes() -> Array<String> {
        return thingTypesFromMirror(Mirror(reflecting: self))
    }

    private func thingTypesFromMirror(mirror: Mirror) -> Array<String> {
        let typeString = String(mirror.subjectType)
        if typeString == "BaseThing" {
            return [typeString]
        } else {
            return [typeString] + thingTypesFromMirror(mirror.superclassMirror()!)
        }
    }

    // Instance variables
    private var attributes : [String: String]
}
