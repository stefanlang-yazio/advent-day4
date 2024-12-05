//
//  CharMatrixTest.swift
//  Day4
//
//  Created by Stefan Lang (work)  on 05.12.24.
//

import Testing

struct CharMatrixTest {
    private let input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    private var sut: CharMatrix {
        return CharMatrix(string: input)
    }

    @Test("Test valid points within the given data")
    func testPointIsValidTrue() async throws {
        #expect( sut.isValidPoint( .init(rowIndex: 0, columnIndex: 0) ))
        #expect( sut.isValidPoint( .init(rowIndex: 1, columnIndex: 3) ))
        #expect( sut.isValidPoint( .init(rowIndex: 9, columnIndex: 9) ))
    }

    @Test("Test no valid points within the given data")
    func testPointIsValidFalse() async throws {
        #expect( !sut.isValidPoint( .init(rowIndex: 0, columnIndex: -1) ))
        #expect( !sut.isValidPoint( .init(rowIndex: -1, columnIndex: 0) ))
        #expect( !sut.isValidPoint( .init(rowIndex: 5, columnIndex: 10) ))
        #expect( !sut.isValidPoint( .init(rowIndex: 10, columnIndex: 5) ))
        #expect( !sut.isValidPoint( .init(rowIndex: 10, columnIndex: 10) ))
    }

    @Test("Test slice for direction left to right returns values ")
    func testSliceLeftToRightSuccess() async throws {
        let direction: SearchDirection = .leftToRight
        var result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 0), length: 4, direction: direction)
        #expect( "MMMS" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 1, columnIndex: 3), length: 3, direction: direction)
        #expect( "MXM" == result )
    }

    @Test("Test slice for direction left to right returns nil ")
    func testSliceLeftToRightNil() async throws {
        let direction: SearchDirection = .leftToRight

        var result = sut.slice(from: CharMatrix.Point(rowIndex: -1, columnIndex: 0), length: 4, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 0), length: 20, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 11, columnIndex: 3), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: -1), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 15, columnIndex: 0), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 12, columnIndex: 12), length: 3, direction: direction)
        #expect( nil == result )
    }

    @Test("Test slice for direction right to left  returns values ")
    func testSliceRightToLeftSuccess() async throws {
        let direction: SearchDirection = .rightToLeft

        var result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 1), length: 2, direction: direction)
        #expect( "MM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 3), length: 4, direction: direction)
        #expect( "SMMM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 4, columnIndex: 4), length: 5, direction: direction)
        #expect( "ASAMX" == result )
    }

    @Test("Test slice for direction right to left returns nil ")
    func testSliceRightToLeftNil() async throws {
        let direction: SearchDirection = .rightToLeft

        var result = sut.slice(from: CharMatrix.Point(rowIndex: -1, columnIndex: 0), length: 4, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 0), length: 4, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 11, columnIndex: 3), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: -1), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 15, columnIndex: 0), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 12, columnIndex: 12), length: 3, direction: direction)
        #expect( nil == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 5, columnIndex: 5), length: 8, direction: direction)
        #expect( nil == result )
    }

    @Test("Test slice for direction vertical down ")
    func testSliceVerticalDownSuccess() async throws {
        let direction: SearchDirection = .verticalDown

        var result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 0), length: 4, direction: direction)
        #expect( "MMAM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 5, columnIndex: 1), length: 4, direction: direction)
        #expect( "XMAA" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 5, columnIndex: 9), length: 4, direction: direction)
        #expect( "ASAM" == result )
    }

    @Test("Test slice for direction vertical up")
    func testSliceVerticalUpSuccess() async throws {
        let direction: SearchDirection = .verticalUp

        var result = sut.slice(from: CharMatrix.Point(rowIndex: 3, columnIndex: 0), length: 4, direction: direction)
        #expect( "MAMM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 7, columnIndex: 7), length: 5, direction: direction)
        #expect( "AXAAS" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 9, columnIndex: 9), length: 4, direction: direction)
        #expect( "XMAS" == result )
    }

    @Test("Test slice for direction diagonal right to left up")
    func testSliceDiagonalRightToLeftUpSuccess() async throws {
        let direction: SearchDirection = .diagonalRightToLeftUp

        var result = sut.slice(from: CharMatrix.Point(rowIndex: 4, columnIndex: 4), length: 4, direction: direction)
        #expect( "AMXS" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 3, columnIndex: 3), length: 4, direction: direction)
        #expect( "MXSM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 9, columnIndex: 9), length: 10, direction: direction)
        #expect( "XMASXAMXSM" == result )
    }

    @Test("Test slice for direction diagonal left to right down")
    func testSliceDiagonalLeftToRightDownSuccess() async throws {
        let direction: SearchDirection = .diagonalLeftToRightDown

        var result = sut.slice(from: CharMatrix.Point(rowIndex: 0, columnIndex: 0), length: 4, direction: direction)
        #expect( "MSXM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 1, columnIndex: 1), length: 4, direction: direction)
        #expect( "SXMA" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 4, columnIndex: 5), length: 3, direction: direction)
        #expect( "MXX" == result )
    }

    @Test("Test slice for direction diagonal left to right up")
    func testSliceDiagonalLeftToRightDownUp() async throws {
        let direction: SearchDirection = .diagonalLeftToRightUp

        var result = sut.slice(from: CharMatrix.Point(rowIndex: 4, columnIndex: 0), length: 4, direction: direction)
        #expect( "XSXM" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 9, columnIndex: 5), length: 4, direction: direction)
        #expect( "XMAS" == result )

        result = sut.slice(from: CharMatrix.Point(rowIndex: 7, columnIndex: 5), length: 3, direction: direction)
        #expect( "ASA" == result )
    }

    @Test("Tests count(occurrencesOf string: String, in directions: [Direction])")
    func testCountOccurrencesOf() async throws {
        var matches = sut.count(occurrencesOf: "XMAS", in: [.leftToRight])
        #expect(3 == matches)

        matches = sut.count(occurrencesOf: "XMAS", in: [.rightToLeft])
        #expect(2 == matches)

        matches = sut.count(occurrencesOf: "XMAS", in: [.leftToRight, .rightToLeft])
        #expect(5 == matches)

        matches = sut.count(occurrencesOf: "XMAS", in: SearchDirection.allCases)
        #expect(18 == matches)
    }
}
