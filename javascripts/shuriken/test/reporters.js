var __slice = Array.prototype.slice, __extends = function(child, parent) {
    var ctor = function(){ };
    ctor.prototype = parent.prototype;
    child.__superClass__ = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
  };
Shuriken.Test.Reporters = {};
(function(reporters) {
  reporters.Reporter = function Reporter(results) {
    this.results = results;
    return this;
  };
  reporters.Reporter.prototype.showResults = function showResults() {
    throw "Please us an implemented reporter.";
  };
  reporters.ConsoleReporter = function ConsoleReporter() {
    return reporters.Reporter.apply(this, arguments);
  };
  __extends(reporters.ConsoleReporter, reporters.Reporter);
  reporters.ConsoleReporter.prototype.showResults = function showResults(results, padding) {
    results = (typeof results !== "undefined" && results !== null) ? results : this.results;
    padding = (typeof padding !== "undefined" && padding !== null) ? padding : 0;
    if ($.isArray(this.results)) {
      // A
    } else if (this.results instanceof Shuriken.Test.ContextResult) {
      // B
    } else if (this.results instanceof Shuriken.Test.AssertionCatcher) {
      // C
    }
  };
  reporters.ConsoleReporter.prototype.puts = function puts() {
    var args;
    args = __slice.call(arguments, 0, arguments.length - 0);
    return console.log.apply(console, ['[Shuriken.Test.Reporters.ConsoleReporter]'].concat(args));
  };
  reporters.ConsoleReporter.prototype.paddedPuts = function paddedPuts(padding) {
    var args;
    args = __slice.call(arguments, 1, arguments.length - 0);
    return padding;
  };
  reporters.ConsoleReporter.prototype.showContext = function showContext(cr, padding) {
    var context;
    padding = (typeof padding !== "undefined" && padding !== null) ? padding : 0;
    context = cr.context;
    this.paddedPuts(padding, ("Context: " + context.name));
    return this.showResults(cr.results, padding + 2);
  };
  reporters.ConsoleReporter.prototype.showTest = function showTest(tr, padding) {
    var assertions;
    padding = (typeof padding !== "undefined" && padding !== null) ? padding : 0;
    assertions = tr.assertions;
    if (assertions.failed()) {
      return this.paddedPuts(padding, "[\u2718]", tr.test.name, ("(" + (assertions.failedReason()) + ")"));
    } else if (assertions.passed() && assertions.passedCount > 0) {
      return this.paddedPuts(padding, "[\u2714]", tr.test.name);
    } else {
      return this.paddedPuts(padding, "[\u203D]", tr.test.name, "(Pending)");
    }
  };
  reporters.ConsoleReporter.prototype.showArray = function showArray(array, padding) {
    var _a, _b, _c, _d, i, lastIndex;
    padding = (typeof padding !== "undefined" && padding !== null) ? padding : 0;
    lastIndex = array.length - 1;
    _a = []; _c = 0; _d = lastIndex;
    for (_b = 0, i = _c; (_c <= _d ? i <= _d : i >= _d); (_c <= _d ? i += 1 : i -= 1), _b++) {
      _a.push((function() {
        this.showResults(array[i], padding);
        if (!(i === lastIndex)) {
          return this.paddedPuts(padding, "");
        }
      }).call(this));
    }
    return _a;
  };
  // Set the current reporter.
  reporters.current = reporters.ConsoleReporter;
  Shuriken.Test.displayResults = function displayResults(results) {
    var reporter;
    reporter = new reporters.current(results);
    return reporter.showResults();
  };
  return Shuriken.Test.displayResults;
})(Shuriken.Test.Reporters);