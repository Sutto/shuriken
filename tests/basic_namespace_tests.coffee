jasmine.include '../javascripts/shuriken.js', true

describe 'Shuriken', ->
  
  root: {}
  
  beforeEach ->
    Shuriken.root: root
    
  afterEach ->
    delete root
    root: {}
    Shuriken.root: root
    
  
  describe 'creating a namespace', ->
    
    it 'should let you create a base namespace', ->
      expect(root.MyNamespace).toBeUndefined()
      Shuriken.as 'MyNamespace'
      expect(root.MyNamespace).toBeDefined()
    
    it 'should let you define a sub namespace', ->
      expect(root.MyNamespace).toBeUndefined()
      Shuriken.as 'MyNamespace'
      expect(root.MyNamespace).toBeDefined()
      expect(root.MyNamespace.X).toBeUndefined()
      expect(root.MyNamespace.Y).toBeUndefined()
      root.MyNamespace.withNS 'X', ->
      expect(root.MyNamespace.X).toBeDefined()
      expect(root.MyNamespace.Y).toBeUndefined()
      root.MyNamespace.withNS 'Y.Z', ->
      expect(root.MyNamespace.X).toBeDefined()
      expect(root.MyNamespace.Y).toBeDefined()
      expect(root.MyNamespace.Y.Z).toBeDefined()
      
    it 'should correctly initialize namespaces as Shuriken.Namespace instances', ->
      Shuriken.as 'MyNamespace'
      root.MyNamespace.withNS 'X', ->
      root.MyNamespace.withNS 'Y.Z', ->
      expect(root.MyNamespace     instanceof Shuriken.Namespace).toBeTruthy()
      expect(root.MyNamespace.X   instanceof Shuriken.Namespace).toBeTruthy()
      expect(root.MyNamespace.Y   instanceof Shuriken.Namespace).toBeTruthy()
      expect(root.MyNamespace.Y.Z instanceof Shuriken.Namespace).toBeTruthy()
  
  describe 'inspecting created namespaces', ->
  
    beforeEach ->
      Shuriken.as 'Doom'
      root.Doom.withNS 'A.B.C', ->
      root.Doom.withNS 'D', ->
      
    it 'should return the correct value for the root namespace', ->
      expect(root.Doom.toNSName()).toEqual 'Doom'
      
    it 'should report the correct value for first level namespace names', ->
      expect(root.Doom.A.toNSName()).toEqual 'Doom.A'
      expect(root.Doom.D.toNSName()).toEqual 'Doom.D'
      
    it 'should expect deeper nested namespaces to have the correct name', ->
      expect(root.Doom.A.B.toNSName()).toEqual 'Doom.A.B'
      expect(root.Doom.A.B.C.toNSName()).toEqual 'Doom.A.B.C'
      
    it 'should correctly report the value of isRoot', ->
      expect(root.Doom.isRoot()).toBeTruthy()
      expect(root.Doom.A.isRoot()).toBeFalsy()
      expect(root.Doom.A.B.isRoot()).toBeFalsy()
      expect(root.Doom.A.B.C.isRoot()).toBeFalsy()
      expect(root.Doom.D.isRoot()).toBeFalsy()
      
    it 'should let you easily get the root namespace', ->
      expect(root.Doom.getRootNS()).toEqual root.Doom
      expect(root.Doom.A.getRootNS()).toEqual root.Doom
      expect(root.Doom.A.B.getRootNS()).toEqual root.Doom
      expect(root.Doom.A.B.C.getRootNS()).toEqual root.Doom
      expect(root.Doom.D.getRootNS()).toEqual root.Doom