# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on 'bust', => @trigger 'win-dealer'
    @get('playerHand').on 'stand', => @get('dealerHand').playToWin()
    @get('dealerHand').on 'bust', => @trigger 'win-player'
    @get('dealerHand').on 'stand', => @findWinner()

  findWinner: ->
    if @get('playerHand').maxScore() > @get('dealerHand').maxScore()
      @trigger 'win-player'
    else if @get('playerHand').maxScore() < @get('dealerHand').maxScore()
      @trigger 'win-dealer'
    else
      @trigger 'push'  