# Shuriken #
## Pointy javascript namespace helpers and stuff ##

Shuriken is a lightweight toolset for JavasScript that provides basic .

Using it is as simple as including the shuriken.js in your app and writing your code:

```javascript
// declare BHM as a root namespace.
var BHM = Shuriken.as('BHM');

// Should print out true.
console.log(BHM instanceof Shuriken.Namespace);

BHM.withNS('Something', function(ns) {
  
  ns.hello = true;
  
  ns.sayHello = function() {
    if(this.hello) console.log("Hello there!");
  };
  
  // Automatically called on page load unless ns.autosetup is set to false.
  ns.setup = function() { this.sayHello(); };
  
});

// On document load, unless BHM.Something.autosetup is false,
// BHM.Something.setup() will be automatically called.
// Also,
BHM.Something.sayHello();
// will say hello manually. I'm sure you get the picture by now.
```
