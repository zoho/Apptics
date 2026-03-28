//
//  Stack.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 18/10/23.
//

import Foundation

protocol StackProtocol{
    associatedtype DataType
    var isEmpty: Bool { get }
    var noOfElements: Int { get }
    func push(_ element: DataType)
    func pop() -> DataType?
    func removeAll()
}


class Stack<T>: StackProtocol, CustomStringConvertible {
    
    var description: String{
        guard !array.isEmpty else {return "Empty"}
        var retStr = ""
        
        array.enumerated().forEach { index,action in
            retStr = retStr + "\(index+1). " + String(describing: action)
            if index != array.count - 1 {
                retStr = retStr + " --> "
            }
        }
        return retStr
    }

    private var array: [T] = []
    
    var noOfElements: Int{
        array.count
    }
    
    
    var isEmpty: Bool {
        array.isEmpty
    }
    
    func push(_ element: T) {
        array.append(element)
    }
    
    func pop() -> T? {
        guard !array.isEmpty else {return nil}
        return array.removeLast()
    }
    
    func removeAll(){
        array.removeAll()
    }
    
}
