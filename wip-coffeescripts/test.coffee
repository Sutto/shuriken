Shuriken.Test = {}

((test) ->

  class test.Context
    
    constructor: (name) ->
      @name:   name
      @blocks: {}
    
    blocksFor: (name) ->
      @blocks[name]?= []
      
    invokeBlocksFor: (name) ->
      block() for block in @blocksFor name
    
    run: ->
      @invokeBlocksFor "beforeAll"
      for test in blocksFor "tests"
        @invokeBlocksFor "setup"
        test.run()
        @invokeBlocksFor "teardown"
      @invokeBlocksFor "afterAll"
      
  class test.Test
    
    constructor: (name, body) ->
      @name: name
      @body: body
      
    run: ->
      @body()
      "Passed"
      

)(Shuriken.Test)