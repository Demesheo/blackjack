class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    if @busted()
      @trigger 'bust', @

  stand: ->
    @trigger 'stand', @
    
  playToWin: ->
    @first().flip()
    while @scores()[0] < 17
      @hit()
    if !@busted()
      @stand

  busted: ->
    @scores()[0] > 21

  maxScore: ->
      scores = @scores()
      if scores[1] <= 21 then scores[1] else scores[0]

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

  # dealerLogic: ->
  #   @models[0].flip()
  #   cardSum = @models[0].attributes.value + @models[1].attributes.value
  #   while cardSum < 17
  #     @add(@deck.pop())
  #     cardSum += @models[@models.length-1].attributes.value
  #   @trigger 'findWinner'

    

