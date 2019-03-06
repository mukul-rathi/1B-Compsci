X = 1 % true X unified to 1
not(X=1) % false, since X can be unified to 1 so fail
not(not(X=1)) % true, since X can be unified to 1 so inner not will be false, so outer not is true
not(not(not(X=1))) % false, since X can be unified to 1 so inner not will be false, so middle not is true so outer not fails.
