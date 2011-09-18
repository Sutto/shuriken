(function(scope, $, undefined) {
  
  // Yah! This is the core of Shuriken's basic namespace support.
  // It provides the bare minimum to support reflection.
  var Namespace = function(parent, name) {
    this.parent = parent;
    this.name   = name;
  };
  Namespace.toString = function() { return 'Shuriken.Namespace'; };
  
  // Setup Prototypical Inheritence.
  var Base = {
    
    autosetup: true,
    
    // Provides a simple way to expose the current namespace to
    // extension. As a bonus, can be called directly on Shuriken.Base
    // to extend ALL namespaces.
    extend: function(extension) {
      var hadSetup = ('setup' in this);
      if(typeof extension == 'function') {
        extension(this);
      } else if(extension) {
        $.extend(this, extension);
      }
      // If we have added a setup function, it should automatically be called on page load.
      if(this.autosetup && 'setup' in this && !hadSetup) {
        $(document).ready($.proxy(this.setup, this));
      }
    },
    
    // Converts the specified namespace into the dotted string notation
    // name so that we can use it for reflection and other stuff.
    toString: function() {
      var parts  = [this.name];
      var parent = this.parent;
      while(parent) {
        parts.unshift(parent.name);
        parent = parent.parent;
      }
      return parts.join('.');
    },
    
    // Lets us declare a child namespace that we wish to 
    withNS: function(name, extension) {
      var parts = name.split(".");
      var ns = this;
      for(var i = 0; i < parts.length; i++) {
        var key = parts[i];
        if(!ns[key]) {
          ns[key] = new Namespace(ns, key);
        }
        ns = ns[key];
      }
      ns.extend(extension);
      return ns;
    }
    
  };
  
  // Prepare prototypical inheritenace for us.
  Namespace.prototype = Base;
  
  // Create shuriken as a namespace and add the sub-NS features to it.
  var Shuriken  = new Namespace(null, 'Shuriken');
  // Shorthand to let us create a new namespace.
  Shuriken.extend({
    Base:      Base,
    Namespace: Namespace,
    as:        function(name) {
      var child        = function() {};
      child.prototype  = new Namespace(null, name);
      scope[name]      = new child;
      scope[name].Base = child.prototype;
      return scope[name];
    }
  });
  // Finally, expose it all to the whole world.
  scope.Shuriken = Shuriken;
  
})(window, jQuery);