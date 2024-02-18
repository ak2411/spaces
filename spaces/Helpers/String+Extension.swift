//
//  String+Extension.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/15/24.
//

import Foundation

extension String: Error, LocalizedError {
    public var errorDescription: String? {self}
}
