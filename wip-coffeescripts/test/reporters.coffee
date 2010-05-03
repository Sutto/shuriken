Shuriken.Test.Reporters: {}

((reporters) ->
  
  class reporters.Reporter
    
    constructor: (results) ->
      @results: results
      
    showResults: () -> throw "Please us an implemented reporter."
    
  class reporters.ConsoleReporter extends reporters.Reporter
    
    showResults: (results, padding) ->
      results?= @results
      padding?= 0
      if $.isArray @results
        # A
      else if @results instanceof Shuriken.Test.ContextResult
        # B
      else if @results instanceof Shuriken.Test.AssertionCatcher
        # C
      
    puts: (args...) -> console.log('[Shuriken.Test.Reporters.ConsoleReporter]', args...)
    
    paddedPuts: (padding, args...) ->
      padding
      
    
    showContext: (cr, padding) ->
      padding?= 0
      context: cr.context
      @paddedPuts padding, "Context: $context.name"
      @showResults cr.results, padding + 2
    
    showTest: (tr, padding) ->
      padding?= 0
      assertions: tr.assertions
      if assertions.failed()
        @paddedPuts padding, "[\u2718]", tr.test.name, "(${assertions.failedReason()})"
      else if assertions.passed() and assertions.passedCount > 0
        @paddedPuts padding, "[\u2714]", tr.test.name
      else
        @paddedPuts padding, "[\u203D]", tr.test.name, "(Pending)"
      
    showArray: (array, padding) ->
      padding?= 0
      lastIndex: array.length - 1
      for i in [0..lastIndex]
        @showResults array[i], padding
        @paddedPuts padding, "" unless i == lastIndex
      
    
  # Set the current reporter.
  reporters.current: reporters.ConsoleReporter
      
  Shuriken.Test.displayResults: (results) ->
    reporter: new reporters.current results
    reporter.showResults()

)(Shuriken.Test.Reporters)