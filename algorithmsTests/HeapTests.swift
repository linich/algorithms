//
//  algorithmsTests.swift
//  algorithmsTests
//
//  Created by Maksim Linich on 24.04.24.
//

import XCTest
@testable import algorithms

struct Heap<T: Comparable> {
    private var items: [T] = Array<T>()
    private var heapSize: Int = 0
    public var isEmpty: Bool {
        return heapSize == 0
    }
    
    public mutating func insert(_ item: T) {
        heapSize += 1
        self.items.append(item)
        
        self.maximize(heapSize - 1)
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
            items[0] = items[heapSize]
            pushDownIfNeed(0)
        }
        
        return item
    }
    
    private func parent(_ i: Int) -> Int {
        return (i - 1 ) / 2
    }
    
    private func left(_ i: Int) -> Int {
        return i*2 + 1
    }
    
    private func right(_ i: Int) -> Int {
        return i*2 + 2
    }
    
    private mutating func maximize(_ i: Int) {
        var index = i
        while index > 0 &&
                items[parent(index)] < items[index] {
            swap(index, parent(index))
            index = parent(index)
        }
                
    }
    
    private mutating func pushDownIfNeed(_ i: Int) {
        var maximum = i
        let l = left(i)
        let r = right(i)
        if l < heapSize && items[maximum] < items[l] {
            maximum = l
        }
        
        if r < heapSize && items[maximum] < items[r] {
            maximum = r
        }
        
        if maximum == i {
            return
        }
        
        swap(maximum, i)
        pushDownIfNeed(maximum)
    }
    
    private mutating func swap(_ i: Int, _ j: Int) {
        let ai = items[i]
        let aj = items[j]
        
        items[i] = aj
        items[j] = ai
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
        
        let _ = sut.pop()
        
        XCTAssertEqual(sut.top, 1, "Expect that top was updated")
    }
    
    func test_pop_shouldPopStorInvariantForHeap() {
        var sut: Heap<Int> = createSUT()
        sut.insert(11)
        sut.insert(2)
        sut.insert(10)
        sut.insert(1)
        sut.insert(12)
        
        assert(&sut, containsItems: [12,11,10,2,1])
    }
    
    // Mark: Helpers
    
    fileprivate func assert<T>(_  sut: inout Heap<T>, containsItems items: [T], file: StaticString = #file, line: UInt = #line) {
        var items = Array<T>()
        
        while !sut.isEmpty {
            items.append(sut.pop())
        }
        
        XCTAssertEqual(items, items, "Items should be in same order", file: file, line: line)
    }
    
    fileprivate func createSUT<T>() -> Heap<T> {
        return Heap<T>()
    }
}
