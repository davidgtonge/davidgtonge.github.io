---
layout: post
title: "Underscore Query"
description: "Intro to library"
category: code
tags: [coffeescript, underscore]
---
{% include JB/setup %}


So this post will be about the new underscore query library and the various API considerations that went into making it..

```coffeescript
testModelAttribute = (queryType, value) ->
  valueType = utils.getType(value)
  switch queryType
    when "$like", "$likeI", "$regex", "$startsWith", "$endsWith"  then valueType is "String"
    when "$contains", "$all", "$any", "$elemMatch" then valueType is "Array"
    when "$size"                      then valueType in ["String","Array"]
    when "$in", "$nin"                then value?
    else true
```

