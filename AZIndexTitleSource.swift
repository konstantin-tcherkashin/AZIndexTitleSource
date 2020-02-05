//
//  AZIndexTitleSource.swift
//  AZIndexTitleSource
//
//  Created by Константин on 2/5/20.
//  Copyright © 2020 Константин. All rights reserved.
//

import Foundation

protocol AZRepresentable {
    var letter: String { get }
    var title: String { get }
}

struct AZIndexTitleSource<T: AZRepresentable> {

    private enum InternalErrors: String, Error {
        case invalidSection
        case invalidRow

        var localizedDescription: String {
            return self.rawValue
        }
    }

    private var source: Array<T>
    private(set) var values: Dictionary<String, Array<T>>!
    private(set) var keys: Array<String>! {
        didSet {
            sectionsCount = keys.count
        }
    }

    init(source _source: Array<T>) {
        source = _source
        configure(with: source)
    }

    private mutating func configure(with array: Array<T>) {
        let dict = Dictionary(grouping: array, by: { $0.letter })

       keys = dict.keys.sorted()
       values = dict.mapValues({
            $0.sorted(by: { $0.title < $1.title })
        })
    }

    private(set) var sectionsCount: Int = 0

    func key(forSection section: Int) throws -> String {
        guard section >= 0, sectionsCount > section else { throw InternalErrors.invalidSection }
        return keys[section]
    }

    func numberOfItems(in section: Int) throws -> Int {
        let _key = try key(forSection: section)
        return values[_key]!.count
    }

    func item(at indexPath: IndexPath) throws -> T {
        let _key = try key(forSection: indexPath.section)
        let currentArray = values[_key]!

        guard indexPath.row >= 0, currentArray.count > indexPath.row  else { throw InternalErrors.invalidRow }
        return currentArray[indexPath.row]
    }

    mutating func set(searchQuery query: String!) {
        guard let query = query, !query.isEmpty else {
            configure(with: source)
            return
        }

        configure(with: source.filter({ $0.title.lowercased().contains(query.lowercased()) }))
    }
}
