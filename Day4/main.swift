//
//  main.swift
//  Day4
//
//  Created by Stefan Lang (work)  on 05.12.24.
//

import Foundation
import Algorithms

let input = """
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

let matrix = CharMatrix(string: input)
let search = "XMAS"

let matchCount = matrix.count(occurrencesOf: search, in: SearchDirection.allCases)
print("Match count \(matchCount)")
