---
layout: page
---
{% include JB/setup %}

{% for post in site.posts limit 3 %}
<h3>{{ post.title }} {% if post.tagline %} <small>{{ post.tagline }}</small>{% endif %}</h3>
{{ post.content }}
<a href="http://news.ycombinator.com/submit" class="hn-share-button">Discuss on HN</a>
<hr>
{% endfor %}
