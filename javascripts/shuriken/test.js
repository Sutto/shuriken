Shuriken.Test = {
  currentContext: []
};
Shuriken.withObject = function withObject(object, block) {
  return with(object) { block.apply(object); };
};
(function(test) {
  test.ContextResult = function ContextResult(context, results) {
    this.context = context;
    this.results = results;
    return this;
  };
  test.TestResult = function TestResult(test, assertions) {
    this.test = test;
    this.assertions = assertions;
    return this;
  };
  test.Context = function Context(name, context) {
    this.name = name;
    this.blocks = {};
    this.context = context;
    return this;
  };
  test.Context.prototype.blocksFor = function blocksFor(name) {
    var _a;
    return this.blocks[name] = (typeof (_a = this.blocks[name]) !== "undefined" && _a !== null) ? this.blocks[name] : [];
  };
  test.Context.prototype.addBlockFor = function addBlockFor(name, block) {
    return this.blocksFor(name).push(block);
  };
  test.Context.prototype.run = function run() {
    var _a, _b, results, scope;
    scope = this.toScope();
    if ((typeof (_a = this.context) !== "undefined" && _a !== null)) {
      this.context.invokeBlocksFor("setupAll", scope);
    }
    this.invokeBlocksFor("setupAll", scope);
    // Invoke all stuff.
    results = [];
    Shuriken.withObject(this, function() {
      results = this.invokeBlocksFor("inner", scope);
      return results;
    });
    this.invokeBlocksFor("teardownAll", scope);
    if ((typeof (_b = this.context) !== "undefined" && _b !== null)) {
      this.context.invokeBlocksFor("teardownAll", scope);
    }
    return new test.ContextResult(this, results);
  };
  test.Context.prototype.toScope = function toScope() {
    var _a, _b, scope, self;
    if ((typeof (_a = this.scope) !== "undefined" && _a !== null)) {
      return this.scope;
    }
    scope = function scope() {    };
    if ((typeof (_b = this.context) !== "undefined" && _b !== null)) {
      scope.prototype = this.context.toScope();
    }
    self = this;
    this.scope = new scope();
    this.scope.setup = function setup() {
      var superSetup;
      superSetup = scope.prototype.setup;
      if ((typeof superSetup !== "undefined" && superSetup !== null)) {
        superSetup.apply(this);
      }
      return self.invokeBlocksFor("setup", this);
    };
    this.scope.teardown = function teardown() {
      var superSetup;
      superSetup = scope.prototype.teardown;
      if ((typeof superTeardown !== "undefined" && superTeardown !== null)) {
        superSetup.apply(this);
      }
      return self.invokeBlocksFor("teardown", this);
    };
    return this.scope.teardown;
  };
  test.Context.prototype.invokeBlocksFor = function invokeBlocksFor(blockName, scope) {
    var _a, _b, _c, _d, block;
    _a = []; _c = this.blocksFor(blockNmae);
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      block = _c[_b];
      _a.push(block.apply(scope));
    }
    return _a;
  };
  test.Context.prototype.setup = function setup(c) {
    return this.addBlockFor("setup", c);
  };
  test.Context.prototype.teardown = function teardown(c) {
    return this.addBlockFor("teardown", c);
  };
  test.Context.prototype.setupAll = function setupAll(c) {
    return this.addBlockFor("setupAll", c);
  };
  test.Context.prototype.teardownAll = function teardownAll(c) {
    return this.addBlockFor("teardownAll", c);
  };
  test.Context.prototype.context = function context(name, block) {
    var context;
    context = new test.Context(name, this);
    block.apply(context);
    return addBlockFor('inner', function() {
      return context.run;
    });
  };
  test.Context.prototype.should = function should(name, block) {
    test = new test.Test(name, block, this);
    return addBlockFor('inner', function() {
      return test.run;
    });
  };
  test.Test = function Test(name, body, context) {
    this.name = name;
    this.body = body;
    this.context = context;
    return this;
  };
  test.Test.prototype.run = function run() {
    var result, scope;
    scope = this.toScope();
    scope.setup();
    result = Shuriken.Test.catchingAssertions(function() {
      return this.body.apply(scope);
    });
    scope.teardown();
    return new test.TestResult(this, result);
  };
  test.Test.prototype.toScope = function toScope() {
    var scope;
    scope = function scope() {    };
    scope.prototype = this.context;
    scope = new scope();
    return scope;
  };
  test.displayResults = function displayResults(results) {  };
  // Do nothing at the moment...
  test.testsFor = function testsFor(name, block) {
    var context;
    context = new test.Context(name);
    test.tests[name] = context;
    Shuriken.withObject(context, block);
    context.runSuite = function runSuite() {
      var results;
      results = this.run();
      return test.displayResults(results);
    };
    return context.runSuite;
  };
  test.tests = {};
  test.runAll = function runAll() {
    var _a, _b, _c, _d, _e, results;
    results = (function() {
      _a = []; _c = test.tests;
      for (_b = 0, _d = _c.length; _b < _d; _b++) {
        test = _c[_b];
        (typeof (_e = test.runSuite) !== "undefined" && _e !== null) ? _a.push(test.run()) : null;
      }
      return _a;
    })();
    return test.displayResults(results);
  };
  return test;
})(Shuriken.Test);