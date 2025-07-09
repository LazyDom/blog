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

#### Follow me on
<div class="social-icons-row">
  <a href="https://medium.com/@LazyDom" target="_blank" rel="noopener" title="Medium" class="social-icon-link">
    <img src="{{ '/assets/images/medium-button.svg' | relative_url }}" alt="Medium" />
  </a>
  <a href="https://github.com/LazyDom" target="_blank" rel="noopener" title="GitHub" class="social-icon-link">
    <img src="{{ '/assets/images/github-mark.svg' | relative_url }}" alt="GitHub" />
  </a>
</div>
