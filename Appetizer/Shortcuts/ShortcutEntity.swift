//
//  ShortcutEntity.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/11/24.
//

import AppIntents

struct Tab: AppEntity, Hashable {
    static var defaultQuery: TabQuery = TabQuery()
    
    typealias DefaultQuery = TabQuery
    
    var id: UUID
    var name: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Tab"
    
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: name)
    }
}

struct TabQuery: EntityQuery {
  func entities(for identifiers: [Tab.ID]) async throws -> [Tab] {
      return AppetizerTabsViewModel.shared.mockData.filter { identifiers.contains($0.id) }
  }

  func suggestedEntities() async throws -> [Tab] {
      return MockData.mockTab
  }
}
