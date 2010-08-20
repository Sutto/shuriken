jasmine.include '../javascripts/shuriken.js', true

describe 'Shuriken', ->

  root = {}

  beforeEach ->
    Shuriken.root = root

  afterEach ->
    delete root
    root = {}
    Shuriken.root = root

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

    it 'should let you get a nested child namespace', ->
      expect(root.Doom.getNS('A')).toEqual     root.Doom.A
      expect(root.Doom.getNS('A.B')).toEqual   root.Doom.A.B
      expect(root.Doom.getNS('A.B.C')).toEqual root.Doom.A.B.C
      expect(root.Doom.getNS('D')).toEqual     root.Doom.D
      expect(root.Doom.A.getNS('B')).toEqual   root.Doom.A.B
      expect(root.Doom.A.getNS('B.C')).toEqual root.Doom.A.B.C
      expect(root.Doom.A.B.getNS('C')).toEqual root.Doom.A.B.C
      expect(root.Doom.getNS('Awesome')).toBeNull()
      expect(root.Doom.getNS('A.Another')).toBeNull()
      expect(root.Doom.getNS('Awesome.Nested')).toBeNull()
      expect(root.Doom.getNS('Awesome.Ouch')).toBeNull()
      expect(root.Doom.getNS('Awesome.Nested.Rocking')).toBeNull()

    it 'should let you inspect the existence of namespaces', ->
      expect(root.Doom.hasNS('A')).toBeTruthy()
      expect(root.Doom.hasNS('A.B')).toBeTruthy()
      expect(root.Doom.hasNS('A.B.C')).toBeTruthy()
      expect(root.Doom.hasNS('D')).toBeTruthy()
      expect(root.Doom.A.hasNS('B')).toBeTruthy()
      expect(root.Doom.A.hasNS('B.C')).toBeTruthy()
      expect(root.Doom.A.B.hasNS('C')).toBeTruthy()
      expect(root.Doom.hasNS('Awesome')).toBeFalsy()
      expect(root.Doom.hasNS('A.Another')).toBeFalsy()
      expect(root.Doom.hasNS('Awesome.Nested')).toBeFalsy()
      expect(root.Doom.hasNS('Awesome.Ouch')).toBeFalsy()
      expect(root.Doom.hasNS('Awesome.Nested.Rocking')).toBeFalsy()

    describe 'Shuriken.Util', ->

      it 'should let you underscore a string', ->
        expect(Shuriken.Util.underscoreize('A')).toEqual 'a'
        expect(Shuriken.Util.underscoreize('A.B')).toEqual 'a/b'
        expect(Shuriken.Util.underscoreize('A.B.C')).toEqual 'a/b/c'
        expect(Shuriken.Util.underscoreize('NameOf.Doom')).toEqual 'name_of/doom'
        expect(Shuriken.Util.underscoreize('Rockin.AndRoll.AndDoom')).toEqual 'rockin/and_roll/and_doom'
        expect(Shuriken.Util.underscoreize('RPXNow')).toEqual 'rpx_now'
        expect(Shuriken.Util.underscoreize('BHM.Authentication.RPXNow')).toEqual 'bhm/authentication/rpx_now'
