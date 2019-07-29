initialization
add: aMethod
	| proxy |
	proxy := MethodCallProxy buildFor: aMethod action: self.
	proxies add: proxy