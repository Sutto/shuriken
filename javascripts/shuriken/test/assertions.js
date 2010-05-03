// General assertions.
Shuriken.Test.Assertions = (function(ns) {
  ns.currentAssertionCatcher = null;
  ns.AssertionCatcher = function AssertionCatcher() {
    this.passedCount = 0;
    this.passedMessages = [];
    this.failedOn = null;
    return this;
  };
  ns.AssertionCatcher.prototype.failAssertion = function failAssertion(e) {
    this.failedOn = e;
    return this.failedOn;
  };
  ns.AssertionCatcher.prototype.passAssertion = function passAssertion(e) {
    this.passedMessages.push(e.message);
    return this.passedCount++;
  };
  ns.AssertionCatcher.prototype.failedReason = function failedReason() {
    var _a;
    if (!(typeof (_a = this.failedOn) !== "undefined" && _a !== null)) {
      return "Not failed";
    }
    return this.failedOn.toString();
  };
  ns.AssertionCatcher.prototype.passed = function passed() {
    return !this.failed();
  };
  ns.AssertionCatcher.prototype.failed = function failed() {
    var _a;
    return (typeof (_a = this.failedOn) !== "undefined" && _a !== null);
  };
  ns.AssertionFailed = function AssertionFailed(message) {
    this.message = message;
    return this;
  };
  ns.AssertionFailed.prototype.toString = function toString() {
    return "Assertion Failed: " + this.message;
  };
  ns.assert = function assert(condition, message) {
    if (condition) {
      // TODO: Track in some sort of test scope.
      return console.log(("Assertion passed: " + message));
    } else {
      throw new ns.AssertionFailed(message);
    }
  };
  ns.assertEqual = function assertEqual(expected, actual, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + actual + ", got " + expected + ".");
    return ns.assert(actual === expected, message);
  };
  ns.assertBlock = function assertBlock(message, block) {
    if (typeof message === "function") {
      block = message;
      message = "expected block to return true";
    }
    return ns.assert(block(), message);
  };
  ns.assertInDelta = function assertInDelta(expected, actual, delta, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("expected " + actual + " and " + expected + " to be within " + delta + " of each other.");
    return ns.assert(Math.abs(expected - actual) <= delta, message);
  };
  ns.assertTypeOf = function assertTypeOf(expected, object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected the type of " + object + " to be " + expected);
    return ns.assert((typeof object === expected), message);
  };
  ns.assertTypeOfIsnt = function assertTypeOfIsnt(expected, object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected the type of " + object + " to not be " + expected);
    return ns.assert((typeof object !== expected), message);
  };
  ns.assertInstanceOf = function assertInstanceOf(expected, object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + object + " to be an instance of " + expected);
    return ns.assert((object instanceof expected), message);
  };
  ns.assertUndefined = function assertUndefined(object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + object + " to be undefined");
    return ns.assertTypeOf('undefined', object, message);
  };
  ns.assertDefined = function assertDefined(object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + object + " to be defined");
    return ns.assertTypeOfIsnt('undefined', object, message);
  };
  ns.assertNotEqual = function assertNotEqual(expected, object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + object + " not to equal " + expected);
    return ns.assert(object !== expected, message);
  };
  ns.assertNull = function assertNull(object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + object + " to be null");
    return ns.assert(object === null, message);
  };
  ns.assertNotNull = function assertNotNull(object, message) {
    message = (typeof message !== "undefined" && message !== null) ? message : ("Expected " + object + " to not be null");
    return ns.assert(object !== null, message);
  };
  ns.flunk = function flunk(message) {
    message = (typeof message !== "undefined" && message !== null) ? message : "Flunking test for no reason";
    return ns.assert(false, ("Flunk: " + message));
  };
  return ns.flunk;
})({});
Shuriken.Test.withAssertions = function withAssertions(closure) {
  return with(Shuriken.Test.Assertions) { closure() };
};
Shuriken.Test.catchingAssertions = function catchingAssertions(closure) {
  var ac, catcher, old;
  ac = Shuriken.Test.AssertionCatcher;
  catcher = new ac();
  old = ac.currentAssertionCatcher;
  ac.currentAssertionCatcher = catcher;
  try {
    closure();
  } catch (e) {
    catcher.failAssertion(e);
  } finally {
    ac.currentAssertionCatcher = old;
  }
  return catcher;
};