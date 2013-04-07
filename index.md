---
layout: page
title: Hello World!
---
{% include JB/setup %}

{% for post in site.posts limit 3 %}
<h3>{{ post.title }} {% if post.tagline %} <small>{{ post.tagline }}</small>{% endif %}</h3>
{{ post.content }}
{% endfor %}
