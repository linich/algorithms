//
//  algorithmsTests.swift
//  algorithmsTests
//
//  Created by Maksim Linich on 24.04.24.
//

import XCTest
@testable import algorithms

struct Heap<T> {
    var item: T?
    public var isEmpty: Bool {
        return item == nil
    }
    
    public mutating func insert(_ item: T) {
        self.item = item
    }
    
    public var top: T? {
        return item
    }
}

final class algorithmsTests: XCTestCase {

    func test_isEmpty_returnsTrueOnInitialize() {
        let sut: Heap<Int> = createSUT()
        XCTAssertTrue(sut.isEmpty)
    }
    
    
    func test_top_returnNilOnEmptyHeap() {
        let sut: Heap<Int> = createSUT()
        XCTAssertNil(sut.top)
    }
    
    func test_top_returnsValidValueForOneInsertedItem() {
        var sut: Heap<Int> = createSUT()
        
        sut.insert(2)
        
        XCTAssertEqual(sut.top, 2, "Expected to receive just inserted item")
    }
    
    func test_isEmpty_returnsFalseAfteInsertItemInHeap() {
        var sut: Heap<Int> = createSUT()
        
        sut.insert(2)
        
        XCTAssertFalse(sut.isEmpty,"Heap should be empty after insertion item in heap")
    }
    
    fileprivate func createSUT<T>() -> Heap<T> {
        return Heap<T>()
    }
}
