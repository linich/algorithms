//
//  algorithmsTests.swift
//  algorithmsTests
//
//  Created by Maksim Linich on 24.04.24.
//

import XCTest
@testable import algorithms

struct Heap<T> {
    private var items: [T] = Array<T>()
    private var heapSize: Int = 0
    public var isEmpty: Bool {
        return heapSize == 0
    }
    
    public mutating func insert(_ item: T) {
        heapSize += 1
        self.items.append(item)
    }
    
    public var top: T? {
        return items.first
    }
    
    public mutating func pop() -> T {
        guard let item = self.items.first else {
            fatalError("Heap is empty")
        }
        
        defer {
            heapSize -= 1
            self.items.removeFirst()
        }
        
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
    
    func test_pop_shouldReturnJustInsertedValue() {
        var sut: Heap<Int> = createSUT()
        
        sut.insert(1)
        
        XCTAssertEqual(sut.pop(), 1, "Expect to pop just inserted value")
    }
    
    func test_isEmpty_returnTrueAfterWePopLastItemFromHeap() {
        var sut: Heap<Int> = createSUT()
        
        sut.insert(1)
        let _ = sut.pop()
        
        XCTAssertTrue(sut.isEmpty, "Expected that pop remove one item from heap")
    }
    
    func test_pop_shouldReturnsItemWithMaxValue() {
        var sut: Heap<Int> = createSUT()
        
        sut.insert(2)
        sut.insert(1)
        
        let item = sut.pop()
        
        XCTAssertEqual(item, 2, "Expect to pop item with max value")
    }
    
    func test_pop_shouldUpdateTop() {
        var sut: Heap<Int> = createSUT()
        
        sut.insert(2)
        sut.insert(1)
        
        let item = sut.pop()
        
        XCTAssertEqual(sut.top, 1, "Expect that top was updated")
    }
    
    fileprivate func createSUT<T>() -> Heap<T> {
        return Heap<T>()
    }
}
