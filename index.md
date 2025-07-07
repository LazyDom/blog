---
layout: default
title: Home
---
# LazyDom's Blog

Welcome to my personal blog repository! Here you’ll find my technical articles, guides, and notes in Markdown format.

## Posts

<ul class="post-list">
  {% for post in site.posts %}
    <li class="post-item">
      <a class="post-link" href="{{ site.baseurl }}{{ post.url }}"><strong>{{ post.title }}</strong></a>
      <span class="post-date">{{ post.date | date: "%B %d, %Y" }}</span>
      {% if post.excerpt %}
        <div class="post-excerpt">{{ post.excerpt | strip_html | truncate: 120 }}</div>
      {% endif %}
    </li>
  {% endfor %}
</ul>

## About

I write about Security, Home Automations, IOT, DevOps, Kubernetes, and other tech topics.  
Feel free to browse, suggest edits, or contribute!

---

Follow me on [Medium](https://medium.com/@LazyDom) or [GitHub](https://github.com/LazyDom) for more updates.
