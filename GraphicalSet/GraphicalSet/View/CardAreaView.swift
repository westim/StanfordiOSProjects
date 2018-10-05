//
//  CardAreaView.swift
//  GraphicalSet
//
//  Created by Timothy West on 9/25/18.
//  Copyright © 2018 Tim West. All rights reserved.
//

import UIKit

class CardAreaView: UIView {

    private lazy var grid = Grid(layout: .aspectRatio(SizeRatio.cardAspectRatio), frame: self.bounds)
    
    /// Cards in the play area.
    var cards: [CardView] {
        return subviews as! [CardView]
    }
    
    func add(_ newCards: [CardView]) {
        newCards.forEach { addSubview($0) }
        resizeGrid()
        newCards.forEach { $0.setup() }
    }
    
    func removeAllCards() {
        cards.forEach { $0.removeFromSuperview() }
    }
    
    private func resizeGrid() {
        grid.cellCount = cards.count
        for index in 0..<cards.count {
            cards[index].frame = grid[index]!
        }
    }
}

// MARK: Constants

private extension CardAreaView {
    private struct SizeRatio {
        
        /// Standard poker cards aspect ratio of 2.5" : 3.5"
        static let cardAspectRatio: CGFloat = 2.5 / 3.5
    }
}
