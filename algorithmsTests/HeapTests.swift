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
    private let by: ((T,T) -> Bool)?
    
    public init() {
        self.by = nil
    }
    
    public init(by: @escaping (T, T) -> Bool) {
        self.by = by
    }
        
    public var isEmpty: Bool {
        return heapSize == 0
    }
    
    public mutating func insert(_ item: T) {
        if heapSize < self.items.count {
            self.items[heapSize] = item
        } else {
            self.items.append(item)
        }
        
        heapSize += 1
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
                compare(items[index], items[parent(index)])  {
            swap(index, parent(index))
            index = parent(index)
        }
    }
    
    private mutating func pushDownIfNeed(_ i: Int) {
        var maximum = i
        let l = left(i)
        let r = right(i)
        if l < heapSize && compare(items[l], items[maximum]) {
            maximum = l
        }
        
        if r < heapSize && compare(items[r], items[maximum]) {
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
    
    private func compare(_ lhs: T, _ rhs: T) -> Bool {
        guard let by = self.by else {
            return lhs > rhs
        }
        
        return by(lhs, rhs)
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
    
    func test_pop_shouldWorksCorrectlyAfterInsertNewItems() {
        var sut: Heap<Int> = createSUT()
        sut.insert(11)
        sut.insert(2)
        sut.insert(10)
        sut.insert(1)
        sut.insert(12)
        
        let _ = sut.pop()
        let _ = sut.pop()
        let _ = sut.pop()
        
        sut.insert(15)
        sut.insert(5)
        sut.insert(0)
        
        assert(&sut, containsItems: [15,5,2,1,0])
    }
    
    func test_pop_shouldWorksInDescendingOrder() {
        var sut: Heap<Int> = createSUT(by: <)
        sut.insert(11)
        sut.insert(2)
        sut.insert(10)
        sut.insert(1)
        sut.insert(12)
        assert(&sut, containsItems: [1,2,10,11,12])
    }
    
    // Mark: Helpers
    
    fileprivate func assert<T>(_  sut: inout Heap<T>, containsItems expected: [T], file: StaticString = #file, line: UInt = #line) {
        var items = Array<T>()
        
        while !sut.isEmpty {
            items.append(sut.pop())
        }
        
        XCTAssertEqual(items, expected, "Items should be in same order", file: file, line: line)
    }
    
    fileprivate func createSUT<T: Comparable>() -> Heap<T> {
        return Heap<T>()
    }
    
    fileprivate func createSUT<T: Comparable>(by: @escaping (T, T) -> Bool) -> Heap<T> {
        return Heap<T>(by: by)
    }
}
