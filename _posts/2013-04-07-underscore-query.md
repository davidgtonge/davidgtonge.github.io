---
layout: post
title: "Underscore Query"
description: "Intro to the Underscore Query library."
category: code
tags: [coffeescript, underscore]
---
{% include JB/setup %}

I use [BackboneJS](http://backbonejs.org/) almost every day. While there are many JavaScript MV* frameworks nowadays,
Backbone hits the sweet spot for me. Backbone doesn't try and do everything for you, and thats why I like it.
It provides solid building blocks for me to develop my apps in the way that makes sense.

The more I code, the more I dislike big monolithic frameworks. They often seem fast to get up and running with, but
when you want to customise something, you essentially have to learn a whole new Domain Specific Language (DSL).

When I first started using Backbone, I found that I was doing a lot of filtering on my collections. I had very long
filter iterators that checked all sorts of model attributes. For example I might want to filter a set of users by date,
name and type - all at the same time.

I realised that my code would be a lot cleaner (and less prone to bugs) if I could simply query my collections. So I
wrote [Backbone Query](https://github.com/davidgtonge/backbone_query) to scratch this itch. It allows Backbone Collections
to be queried using an API similar to MongoDB. I first wrote the project at the beginning of 2012. Its been pretty useful
for me, however it has a major shortcoming - it only works on Backbone Collections. Many times I found myself putting
data into a Backbone Collection simply to query it.

I decided to rewrite the library to work with native JavaScript arrays. While adapting the libarary I've also added
some other useful options to the API. I've been doing a lot of work with [D3.js](http://d3js.org) and I love its simple
fluent API. Take this D3 example:

```javascript
d3.selectAll("circle")
  .transition()
  .duration(1000)
  .attr("r",100);
```

The above code selects some circle elements, and transitions their radius to 100 over the course of 1s.
A similar type of animation with jQuery would be like this:

```javascript
$('circle').animate({
  r: 100
}, 1000);
```

With a simple example, there's not a massive difference in the code. But when we add some more complexity, D3 begins
to shine:

```javascript
var transition = d3.selectAll("g")
  .transition()
  .duration(1000)
  .delay(function(d,i) { return i * 100 } );

transition.select("circle").attr("r", 100)
transition.select("rect").attr("width", 150)
```

This time I'm transitioning some `g` elements. Each transition is 1s long, but each `g` element will start the transition
100ms after the previous one. Furthermore I'm not actually changing any attribute on the `g`, but I'm rather changing
the radius of the `circle` within the `g` and the width of the `rect` within the `g`. To perform something similar with
jQuery would be a lot harder. D3's API is very powerful because many of its methods return objects with methods to
further adjust the operation. So the `transition` method returns an object that has a `delay` and `duration` methods.
I've found this type of API to be a far more useful than have to call methods with a big `options` object or many
arguments.

For `underscore query` I've implemeneted something similar. Where as before you would query like this:

```javascript
_.query(collection, {
  $and:{
    {status:"published"}
  },
  $or: {
    {tags: ["javascript","coffeescript"]},
    {likes: {$gt: 10}}
  }
});
```
You can now query like this:

```javascript
_.query(collection)
  .and("status","published")
  .or("tags", ["javascript","coffeescript"[)
  .or("likes",{$gt:10})
  .find()
```

I think the 2nd version is more readable and easier to use. It also enables some features that were not possible with
the old version. For example using the same query for multiple collections:

```javascript
var query = _.query().and("likes",{$gt:10})
var resultsA = query(collectionA)
var resultsB = query(collectionB)
```

After building the library to work with basic arrays, it was fairly easy to add the option to use with Backbone by adding
a `getter` option. This can be defined as a string or a function. In Backbone Models, the `get` method is used to access
Model attributes, so we simply need to pass in `"get"` as a string:

```javascript
var Collection = Backbone.Collection.extend({
  query: function (params) { return _.query(this.models, params, "get") }
})
```

With one simple line all my Backbone Collections can use the functionality of underscore query. If a function is
supplied as a getter then it will be called on each iteration of the query with the object being queried and the current
query key. This should enable the library to work with a variety of different frameworks.

Benjamin Lupton's [Query Engine](https://github.com/bevry/query-engine) is a similar library to Backbone Query. One of
the extra features that it has is the ability to have *live collections*. I wanted to add this as an option to Backbone
Query, however I wanted a minimal and flexible implementation that developers could easily adapt to meet their own
specific use cases:

```javascript
var Collection = Backbone.Collection.extend({
  setFilter: function (parent, query) {
    query = _.query.parse(query)
    var check = function (model) { return _.query([model], query, "get", true).length }

    this.listenTo(parent, {
      add: function (model) { check(model) ? this.add(model) : null },
      remove: this.remove,
      change: function (model) { check(model) ? this.add(model) : this.remove(model) }
    })

    this.add(_.query(parent.models, query, "get", true))
  }
});
```

The above code implements a `setFilter` method which accepts a *parent* collection and a query object. The idea is that
the filtered collection will contain a continually updated filtered sub-set of the parent collection's models. Here's
a breakdown of what the above code does:

1. Parses the supplied query object (rather than re-parsing it on each query operation)
2. Creates a `check` function that will be used to determine if indivudal model's should be in the collection
3. Sets up events on the parent collection listening to the `add`, `remove` and `change` events. These events ensure that
the filtered collection is always up to date with the parent.
4. Add any existing models from the parent collection to the filtered collection, if they pass the test.

I think that this code shows the power of Backbone in allowing powerful data manipulation with relative little code.










```


