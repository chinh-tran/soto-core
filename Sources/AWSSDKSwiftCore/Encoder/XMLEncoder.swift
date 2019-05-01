import Foundation

public class XMLEncoder {
    public init() {}
    
    open func encode<T : Encodable>(_ value: T, name: String? = nil) throws -> XMLElement {
        let encoder = _XMLEncoder(name ?? "\(type(of: value))")
        try value.encode(to: encoder)
        return encoder.elements[0]
    }
}

class _XMLEncoder : Encoder {
    let name : String
    var elements : [XMLElement] = []
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    init(_ elementName : String) {
        self.name = elementName
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let element = XMLElement(name: name)
        elements.append(element)
        return KeyedEncodingContainer(KEC(element))
    }
    
    class KEC<Key: CodingKey> : KeyedEncodingContainerProtocol {
        let element : XMLElement
        var codingPath: [CodingKey] = []
        
        init(_ element : XMLElement) {
            self.element = element
        }
        
        func encodeNil(forKey key: Key) throws {
            fatalError()
        }
        
        func encode(_ value: Bool, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: value.description)
            element.addChild(childElement)
        }
        
        func encode(_ value: String, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: value)
            element.addChild(childElement)
        }
        
        func encode(_ value: Double, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Float, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Int, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Int8, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Int16, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Int32, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Int64, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: UInt, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: UInt8, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: UInt16, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: UInt32, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: UInt64, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: NSNumber(value:value).description)
            element.addChild(childElement)
        }
        
        func encode(_ value: Data, forKey key: Key) throws {
            let childElement = XMLElement(name: key.stringValue, stringValue: value.base64EncodedString())
            element.addChild(childElement)
        }
        
        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            let encoder = _XMLEncoder(key.stringValue)
            try value.encode(to: encoder)
            for child in encoder.elements {
                element.addChild(child)
            }
        }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            fatalError()
        }
        
        func superEncoder() -> Encoder {
            fatalError()
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            fatalError()
        }
        
        
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UKEC(self)
    }
    
    class UKEC : UnkeyedEncodingContainer {
        
        var referencing : _XMLEncoder
        var codingPath: [CodingKey] = []
        var count : Int

        init(_ encoder: _XMLEncoder) {
            self.referencing = encoder
            self.count = 0
        }
        
        func encode(_ value: String) throws {
            fatalError()
        }
        
        func encode(_ value: Double) throws {
            fatalError()
        }
        
        func encode(_ value: Float) throws {
            fatalError()
        }
        
        func encode(_ value: Int) throws {
            fatalError()
        }
        
        func encode(_ value: Int8) throws {
            fatalError()
        }
        
        func encode(_ value: Int16) throws {
            fatalError()
        }
        
        func encode(_ value: Int32) throws {
            fatalError()
        }
        
        func encode(_ value: Int64) throws {
            fatalError()
        }
        
        func encode(_ value: UInt) throws {
            fatalError()
        }
        
        func encode(_ value: UInt8) throws {
            fatalError()
        }
        
        func encode(_ value: UInt16) throws {
            fatalError()
        }
        
        func encode(_ value: UInt32) throws {
            fatalError()
        }
        
        func encode(_ value: UInt64) throws {
            fatalError()
        }
        
        func encode<T>(_ value: T) throws where T : Encodable {
            let encoder = _XMLEncoder(referencing.name)
            try value.encode(to: encoder)
            referencing.elements.append(contentsOf:encoder.elements)
        }
        
        func encode(_ value: Bool) throws {
            fatalError()
        }
        
        func encodeNil() throws {
            fatalError()

        }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            fatalError()
        }
        
        func superEncoder() -> Encoder {
            fatalError()
        }
        
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        //let element = XMLElement(name: name)
        //elements.append(element)
        return SVEC(self)
    }
    
    class SVEC : SingleValueEncodingContainer {
        let referencing : _XMLEncoder
        var codingPath: [CodingKey] = []
        
        init(_ encoder : _XMLEncoder) {
            self.referencing = encoder
        }
        
        func encodeNil() throws {
//            fatalError()
        }
        
        func encode(_ value: Bool) throws {
            let element = XMLElement(name: referencing.name, stringValue: value.description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: String) throws {
            let element = XMLElement(name: referencing.name, stringValue: value)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Double) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Float) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Int) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Int8) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Int16) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Int32) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: Int64) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: UInt) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: UInt8) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: UInt16) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: UInt32) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode(_ value: UInt64) throws {
            let element = XMLElement(name: referencing.name, stringValue: NSNumber(value:value).description)
            referencing.elements.append(element)
        }
        
        func encode<T>(_ value: T) throws where T : Encodable {
            let encoder = _XMLEncoder(referencing.name)
            try value.encode(to: encoder)
            for child in encoder.elements {
                referencing.elements.append(child)
            }
        }
    }
}
