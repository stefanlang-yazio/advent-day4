//
//  CharMatrix.swift
//  Day4
//
//  Created by Stefan Lang (work)  on 05.12.24.
//

import Foundation

enum SearchDirection: CaseIterable {
    case leftToRight
    case rightToLeft
    case verticalDown
    case verticalUp
    case diagonalLeftToRightUp
    case diagonalLeftToRightDown
    case diagonalRightToLeftDown
    case diagonalRightToLeftUp
}

struct CharMatrix: Sequence {
    struct Point {
        let rowIndex: Int // vertical / y
        let columnIndex: Int // vorizontal / x

        func plus(column: Int) -> Point {
            return Point(rowIndex: self.rowIndex, columnIndex: self.columnIndex + column)
        }

        func plus(row: Int) -> Point {
            return Point(rowIndex: self.rowIndex + row, columnIndex: self.columnIndex)
        }
    }

    let data: [[Substring.Element]]

    var columnCount: Int {
        data.first?.count ?? 0
    }

    var rowCount: Int {
        data.count
    }

    init(data: [[Substring.Element]]) {
        self.data = data
    }

    init(string input: String) {
        let lines = input.split(separator: "\n")
        let data = lines.map { Array($0) }

        self.init(data: data)
    }

    func isValidPoint(_ point: Point) -> Bool {
        guard (0..<rowCount).contains(point.rowIndex) else {
            return false
        }

        guard (0..<data[point.rowIndex].count).contains(point.columnIndex) else {
            return false
        }

        return true
    }

    func count(occurrencesOf string: String, in directions: [SearchDirection]) -> Int {
        if string.isEmpty {
            return 0
        }

        var matchCount = 0
        for (rowIndex, columnIndex, _) in self {
            let char = data[rowIndex][columnIndex]

            if char != string.first {
                continue
            }

            directions.forEach { direction in
                let currString = self.slice(rowIndex: rowIndex, columnIndex: columnIndex, length: string.count, direction: direction)
                if currString == string {
                    matchCount += 1
                }
            }
        }

        return matchCount
    }

    @inlinable
    func get(at point: Point) -> String? {
        guard isValidPoint(point) else {
            return nil
        }

        return String(data[point.rowIndex][point.columnIndex])
    }

    @inlinable
    func get(_ rowIndex: Int, _ columnIndex: Int) -> String? {
        return get(at: Point(rowIndex: rowIndex, columnIndex: columnIndex))
    }

    @inlinable
    func getOrElse(_ rowIndex: Int, _ columnIndex: Int, fallback: String) -> String {
        return get(at: Point(rowIndex: rowIndex, columnIndex: columnIndex)) ?? fallback
    }

    @inlinable
    func getOrEmpty(_ rowIndex: Int, _ columnIndex: Int) -> String {
        return getOrElse(rowIndex, columnIndex, fallback: "")
    }

    func slice(
        rowIndex: Int,
        columnIndex: Int,
        length: Int,
        direction: SearchDirection
    ) -> String? {
        return slice(from: Point(rowIndex: rowIndex, columnIndex: columnIndex), length: length, direction: direction)
    }

    func slice(
        from point: Point,
        length: Int,
        direction: SearchDirection
    ) -> String? {
        switch direction {
        case .leftToRight:
            return sliceLeftToRight(from: point, length: length)
        case .rightToLeft:
            return sliceRightToLeft(from: point, length: length)
        case .verticalDown:
            return sliceVerticalDown(from: point, length: length)
        case .verticalUp:
            return sliceVerticalUp(from: point, length: length)
        case .diagonalLeftToRightUp:
            return sliceDiagonalLeftToRightUp(from: point, length: length)
        case .diagonalLeftToRightDown:
            return sliceDiagonalLeftToRightDown(from: point, length: length)
        case .diagonalRightToLeftDown:
            return sliceDiagonalRightToLeftDown(from: point, length: length)
        case .diagonalRightToLeftUp:
            return sliceDiagonalRightToLeftUp(from: point, length: length)
        }
    }

    func makeIterator() -> AnyIterator<(Int, Int, Substring.Element)> {
        var rowIndex = 0
        var columnIndex = 0

        return AnyIterator {
            if rowIndex < self.data.count {
                if columnIndex < self.data[rowIndex].count {
                    let element = self.data[rowIndex][columnIndex]
                    let result = (rowIndex, columnIndex, element)
                    columnIndex += 1

                    if columnIndex == self.data[rowIndex].count {
                        columnIndex = 0
                        rowIndex += 1
                    }

                    return result
                }

                rowIndex += 1
                columnIndex = 0
            }

            return nil
        }
    }

    private func sliceLeftToRight(from point: Point, length: Int) -> String? {
        guard isValidPoint(point) else {
            return nil
        }

        let endPoint = point.plus(column: length - 1)

        guard isValidPoint(endPoint) else {
            return nil
        }

        let row = data[point.rowIndex]
        let slice = String(row[point.columnIndex...endPoint.columnIndex])

        return slice
    }

    private func sliceRightToLeft(from point: Point, length: Int) -> String? {
        guard isValidPoint(point) else {
            return nil
        }

        let startPoint = point.plus(column: -(length - 1))

        guard isValidPoint(startPoint) else {
            return nil
        }

        let row = data[point.rowIndex]
        let slice = String(row[startPoint.columnIndex...point.columnIndex].reversed())

        return slice
    }

    private func sliceVerticalDown(from point: Point, length: Int) -> String? {
        guard isValidPoint(point) else {
            return nil
        }

        let endPoint = point.plus(row: length - 1 )

        guard isValidPoint(endPoint) else {
            return nil
        }

        var slice = ""
        for rowIndex in point.rowIndex...endPoint.rowIndex {
            slice += getOrEmpty(rowIndex, point.columnIndex)
        }

        return slice
    }

    private func sliceVerticalUp(from point: Point, length: Int) -> String? {
        guard isValidPoint(point) else {
            return nil
        }

        let startPoint = point.plus(row: -(length - 1) )

        guard isValidPoint(startPoint) else {
            return nil
        }

        var slice = ""
        for rowIndex in startPoint.rowIndex...point.rowIndex {
            slice = getOrEmpty(rowIndex, point.columnIndex) + slice
        }

        return slice
    }

    private func sliceDiagonalRightToLeftUp(from point: Point, length: Int) -> String? {
        let endPoint = point.plus(column: -(length - 1)).plus(row: -(length - 1))

        guard isValidPoint(endPoint) else {
            return nil
        }

        var slice = ""
        for i in 0..<length {
            let nextPoint = point.plus(column: -i).plus(row: -i)
            slice += getOrEmpty(nextPoint.rowIndex, nextPoint.columnIndex)
        }

        return slice
    }

    private func sliceDiagonalRightToLeftDown(from point: Point, length: Int) -> String? {
        let endPoint = point.plus(column: -(length - 1)).plus(row: (length - 1))

        guard isValidPoint(endPoint) else {
            return nil
        }

        var slice = ""
        for i in 0..<length {
            let nextPoint = point.plus(column: -i).plus(row: i)
            slice += getOrEmpty(nextPoint.rowIndex, nextPoint.columnIndex)
        }

        return slice
    }

    private func sliceDiagonalLeftToRightDown(from point: Point, length: Int) -> String? {
        let endPoint = point.plus(column: (length - 1)).plus(row: (length - 1))

        guard isValidPoint(endPoint) else {
            return nil
        }

        var slice = ""
        for i in 0..<length {
            let nextPoint = point.plus(column: i).plus(row: i)
            slice += getOrEmpty(nextPoint.rowIndex, nextPoint.columnIndex)
        }

        return slice
    }

    private func sliceDiagonalLeftToRightUp(from point: Point, length: Int) -> String? {
        let endPoint = point.plus(column: (length - 1)).plus(row: -(length - 1))

        guard isValidPoint(endPoint) else {
            return nil
        }

        var slice = ""
        for i in 0..<length {
            let nextPoint = point.plus(column: i).plus(row: -i)
            slice += getOrEmpty(nextPoint.rowIndex, nextPoint.columnIndex)
        }

        return slice
    }
}
