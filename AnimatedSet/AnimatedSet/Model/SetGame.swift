//
//  SetGame.swift
//  Set
//
//  Created by Timothy West on 8/28/18.
//  Copyright © 2018 Tim West. All rights reserved.
//

import Foundation

class SetGame {
    
    var deck = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var dealtCards = [Card]()
    private(set) var recentlyDealtCards = [Card]()
    private(set) var score = 0
    
    /// End game state is when there are no dealt cards & the deck is empty.
    var gameOver: Bool {
        return dealtCards.isEmpty && deck.isEmpty
    }
    
    /// Determines if the current selected set is a match.
    /// If current selection isn't a complete set, return `nil`.
    var selectedSetMatches: Bool? {
        return try? Card.makesSet(selectedCards)
    }
    
    init() {
        startGame()
    }
    
    /**
     Populates the deck with all possible card variations, shuffled randomly.
     
     - Returns: Shuffled deck of `Card`
     */
    private func createDeck() -> [Card] {
        var newDeck = [Card]()
        for attribute1 in Card.Variant.all {
            for attribute2 in Card.Variant.all {
                for attribute3 in Card.Variant.all {
                    for attribute4 in Card.Variant.all {
                        newDeck.append(Card(Att1: attribute1, Att2: attribute2, Att3: attribute3, Att4: attribute4))
                    }
                }
            }
        }
        newDeck.shuffle()
        return newDeck
    }
    
    /**
     Shuffles the current played cards.
     */
    func shufflePlayedCards() {
        dealtCards.shuffle()
    }
    
    /**
     Deals the first 12 cards from the deck & resets the score.
     */
    func startGame() {
        deck = createDeck()
        dealtCards = Array(deck[0..<12])
        deck.removeSubArray(subarray: dealtCards)
    }
    
    /**
     Deals 3 cards from the deck. If the selected set
     matches, replace the selected set. Otherwise, add the
     cards to the collection of dealt cards.
     
     - Returns: Cards that are dealt.
     */
    func dealCards() {
        let numberOfCardsToDeal = deck.count < 3 ? deck.count : 3
        let dealCards = Array(deck[0..<numberOfCardsToDeal])
        
        if let isMatch = selectedSetMatches, isMatch {  // Replace selected, matching cards
            replaceSelectedCards(using: dealCards)
        } else {  // Add cards to the game
            dealtCards.append(contentsOf: dealCards)
        }
        deck.removeSubArray(subarray: dealCards)
        recentlyDealtCards = dealCards
    }
    
    /**
     Replaces the selected cards with new cards from the deck.
     If there are not enough cards from the deck, simply remove
     the dealt card from the game.
     */
    private func replaceSelectedCards(using newCards: [Card]) {
        for selectedCardIndex in selectedCards.indices {
            guard let dealtCardIndex = dealtCards.index(of: selectedCards[selectedCardIndex]) else { return }
            if selectedCardIndex < newCards.count {
                dealtCards[dealtCardIndex] = newCards[selectedCardIndex]
            } else {
                dealtCards.remove(at: dealtCardIndex)
            }
        }
        selectedCards.removeAll()
    }
    
    /**
     Acts on the clicked `Card` according to the game rules.
     
     - Parameter clickedCard: The card that was selected by the player.
     */
    func selectCard(clickedCardIndex: Int) {
        if let index = selectedCards.index(of: dealtCards[clickedCardIndex]), selectedCards.count != 3 {  // Deselect clicked card
            score -= 1
            selectedCards.remove(at: index)
        } else {
             if let isMatched = selectedSetMatches, !isMatched {  // Deselect unmatched set & select clicked card
                score -= 5
                selectedCards.removeAll()
            } else if let isMatched = selectedSetMatches, isMatched {  // Replace matched set
                score += 3
                dealCards()
            } else {  // Select clicked card
                selectedCards.append(dealtCards[clickedCardIndex])
            }
        }
    }
    
    func expireTurn() {
        score -= 2
        selectedCards.removeAll()
    }
}
