# General assertions.
Shuriken.Test.Assertions: ((ns) ->
  
  class ns.AssertionFailed
    
    constructor: (message) ->
      @message: message
      
    toString: ->
      "Assertion Failed: $@message"
  
  ns.assert: (condition, message) ->
    if condition
      # TODO: Track in some sort of test scope.
      console.log "Assertion passed: $message"
    else
      throw new ns.AssertionFailed message
  
  ns.assertEqual: (expected, actual, message) ->
    message?= "Expected $actual, got $expected."
    ns.assert actual is expected, message
  
  ns.assertBlock: (message, block) ->
    if typeof message is "function"
      block: message
      message: "expected block to return true"
    ns.assert block(), message
  
  ns.assertInDelta: (expected, actual, delta, message) ->
    message?= "expected $actual and $expected to be within $delta of each other."
    ns.assert Math.abs(expected - actual) <= delta, message
  
  ns.assertTypeOf: (expected, object, message) ->
    message?= "Expected the type of $object to be $expected"
    ns.assert (typeof object is expected), message
    
  ns.assertTypeOfIsnt: (expected, object, message) ->
    message?= "Expected the type of $object to not be $expected"
    ns.assert (typeof object isnt expected), message
  
  ns.assertInstanceOf: (expected, object, message) ->
    message?= "Expected $object to be an instance of $expected"
    ns.assert (object instanceof expected), message
    
  ns.assertUndefined: (object, message) ->
    message?= "Expected $object to be undefined"
    ns.assertTypeOf 'undefined', object, message
  
  ns.assertDefined: (object, message) ->
    message?= "Expected $object to be defined"
    ns.assertTypeOfIsnt 'undefined', object, message
    
  ns.assertNotEqual: (expected, object, message) ->
    message?= "Expected $object not to equal $expected"
    ns.assert object isnt expected, message
    
  ns.assertNull: (object, message) ->
    message?= "Expected $object to be null"
    ns.assert object is null, message
    
  ns.assertNotNull: (object, message) ->
    message?= "Expected $object to not be null"
    ns.assert object isnt null, message
    
  ns.flunk: (message) ->
    message?= "Flunking test for no reason"
    ns.assert false, "Flunk: $message"
  
)({})

Shuriken.Test.withAssertions: (closure) ->
  `with(Shuriken.Test.Assertions) { closure() }`