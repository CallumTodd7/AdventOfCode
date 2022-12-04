//
//  String+.swift
//  
//
//  Created by Callum Todd on 04/12/2022.
//

import Foundation

extension String {
    var lines: [String] {
        Array(
            self.components(separatedBy: .newlines)
                .trimming(while: \.isEmpty)
        )
    }
}
