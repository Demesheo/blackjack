class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    if @length  < 5 
      cardSum = 0
      i = 0
      while i < @models.length
        cardSum += @models[i].attributes.value
        i++      
      if cardSum <= 21
        @add(@deck.pop())

  stand: ->
    console.log 'stand'
    
  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  dealerLogic: ->
    @models[0].flip()
    cardSum = @models[0].attributes.value + @models[1].attributes.value
    while cardSum < 17
      @add(@deck.pop())
      cardSum += @models[@models.length-1].attributes.value
      console.log cardSum
    # trigger that the round has ended
    @trigger 'calcScorer'   
    

