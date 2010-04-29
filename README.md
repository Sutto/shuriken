# Shuriken #
## Pointy javascript namespace helpers and stuff ##

Shuriken is a lightweight toolset for Javascript, written in coffeescript
that provides a lightweight implementation of namespaces and a few other things
(e.g. mixins) that I've found have simplified structured javascript development.

Using it is as simple as including the shuriken.js in your app and writing your code:

    // declare BHM as a root namespace.
    Shuriken.as('BHM');
    
    // Should print out true.
    console.log(BHM instanceof Shuriken.Namespace);
    
    BHM.withNS('Something', function(ns) {
      
      ns.hello = true;
      
      ns.sayHello = function() {
        if(ns.hello) console.log("Hello there!");
      };
      
      ns.setup = function() {
        ns.sayHello();
      };
      
    });

    // On document load, unless BHM.autosetup is false,
    // BHM.Something.setup() will be automatically called.
    // Also,
    BHM.Something.sayHello();
    // will say hello manually. I'm sure you get the picture by now.


