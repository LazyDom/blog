---
layout: default
title: Home
---
# LazyDom's Blog

Welcome to my personal blog repository! Here you’ll find my technical articles, guides, and notes in Markdown format.

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a> - {{ post.date | date: "%B %d, %Y" }}
    </li>
  {% endfor %}
</ul>

## About

I write about Security, Home Automations, IOT, DevOps, Kubernetes, and other tech topics.  
Feel free to browse, suggest edits, or contribute!

---

Follow me on 
<a href="https://medium.com/@LazyDom" target="_blank" rel="noopener">
  <img src="{{ site.baseurl }}/assets/images/medium-button.png" alt="Medium">
</a>
<a href="https://github.com/LazyDom" target="_blank" rel="noopener">
  <img src="{{ site.baseurl }}/assets/images/github-mark.png" alt="GitHub">
</a>
for more updates.
