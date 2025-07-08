---
title: Home
layout: default
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
![]({{ '/assets/images/medium-button.png' | relative_url }})
[Medium](https://medium.com/@LazyDom)
![]({{ '/assets/images/github-mark.png' | relative_url }})
[GitHub](https://github.com/LazyDom)
for more updates.
