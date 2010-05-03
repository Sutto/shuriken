Shuriken.Test = {
  currentContext: []
}

Shuriken.withObject: (object, block) ->
  `with(object) { block.apply(object); }`

((test) ->

  class test.ContextResult
    
    constructor: (context, results) ->
      @context: context
      @results: results

  class test.TestResult

    constructor: (test, assertions) ->
      @test: test
      @assertions: assertions

  class test.Context
    
    constructor: (name, context) ->
      @name:   name
      @blocks: {}
      @context: context
    
    blocksFor: (name) ->
      @blocks[name]?= []
      
    addBlockFor: (name, block) ->
      @blocksFor(name).push block
    
    run: ->
      scope: @toScope()
      @context.invokeBlocksFor "setupAll", scope if @context?
      @invokeBlocksFor "setupAll", scope
      # Invoke all stuff.
      results: []
      Shuriken.withObject @, -> results: @invokeBlocksFor("inner", scope)
      @invokeBlocksFor "teardownAll", scope
      @context.invokeBlocksFor "teardownAll", scope if @context?
      new test.ContextResult @, results
      
    toScope: ->
      return @scope if @scope?
      scope: ->
      scope.prototype: @context.toScope() if @context?
      self: @
      @scope: new scope()
      @scope.setup: ->
        superSetup: scope::setup
        superSetup.apply(@) if superSetup?
        self.invokeBlocksFor "setup", @
      @scope.teardown: ->
        superSetup: scope::teardown
        superSetup.apply(@) if superTeardown?
        self.invokeBlocksFor "teardown", @
        
    invokeBlocksFor: (blockName, scope) ->
      block.apply(scope) for block in @blocksFor(blockNmae)
    
    setup:       (c) -> @addBlockFor "setup",       c
    teardown:    (c) -> @addBlockFor "teardown",    c
    setupAll:    (c) -> @addBlockFor "setupAll",    c
    teardownAll: (c) -> @addBlockFor "teardownAll", c
      
    context: (name, block) ->
      context: new test.Context name, @
      block.apply context
      addBlockFor 'inner', -> context.run
      
    should: (name, block) ->
      test: new test.Test name, block, @
      addBlockFor 'inner', -> test.run
      
  class test.Test
    
    constructor: (name, body, context) ->
      @name:    name
      @body:    body
      @context: context
      
    run: ->
      scope = @toScope()
      scope.setup()
      result: Shuriken.Test.catchingAssertions -> @body.apply scope
      scope.teardown()
      new test.TestResult @, result
      
    toScope: ->
      scope: ->
      scope.prototype: @context
      scope: new scope()
      
  
  test.displayResults: (results) ->
    # Do nothing at the moment...
  
  test.testsFor: (name, block) ->
    context: new test.Context name
    test.tests[name]: context
    Shuriken.withObject context, block
    context.runSuite: ->
      results: @run()
      test.displayResults results
      
  test.tests: {}
  
  test.runAll: ->
    results: test.run() for test in test.tests when test.runSuite?
    test.displayResults results
    
  test 

)(Shuriken.Test)