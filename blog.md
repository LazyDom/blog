---
title: Blog
layout: default
permalink: /blog/
description: All posts and guides by LazyDom on security, automation, DevOps, and tech.
tagline: All my posts and guides on security, automation, and tech.
---
# LazyDom's Blog

Welcome to my personal blog about Security, Home Automation, IOT, DevOps, Kubernetes and more!! Here you’ll find my technical articles, guides, and notes.

## Posts

<ul class="post-list">
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a> - {{ post.date | date: "%B %d, %Y" }}
      <p>{{ post.excerpt }}</p>
    </li>
  {% endfor %}
</ul>

Feel free to browse, suggest edits, or contribute — bonus points if you find my typos before I do!