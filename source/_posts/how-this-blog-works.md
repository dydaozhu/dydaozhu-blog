---
title: 这个博客是怎么搭的
date: 2026-10-24 13:00:00
categories:
  - 折腾
tags:
  - Hexo
  - Cloudflare
description: 记录这套技术选型的理由，方便以后自己回看。
---

## 整体结构

```
浏览器写 Markdown → 提交到 GitHub → Cloudflare Pages 自动构建 → 上线
```

没有服务器，没有数据库，也没有管理后台进程。内容就是仓库里的一堆 `.md` 文件。

## 为什么这么选

| 组成 | 选择 | 理由 |
| --- | --- | --- |
| 生成器 | Hexo + Butterfly | 中文生态好，主题开箱可用 |
| 托管 | Cloudflare Pages | 免费、带宽不限、和域名 DNS 在同一处 |
| 内容 | Markdown + GitHub | 纯文本，永远不怕平台跑路 |
| 后台 | Pages CMS | 图形化编辑，不用装 Node |

## 写作流程

```bash
# 本地预览（可选，需要装 Node）
npm install
npm run server   # http://localhost:4000

# 写完提交
git add .
git commit -m "新文章：xxx"
git push
```

推送之后 Cloudflare 会自动构建，一两分钟后线上就更新了。

{% note info 关于草稿 %}
不想立刻公开的文章，在 front-matter 里加一行 `draft: true` 就不会被生成。
这个项目没开 `render_drafts`，所以草稿想本地预览得临时改配置。
{% endnote %}

## 想改的话

- 站点信息：`_config.yml` 顶部
- 主题外观：`_config.butterfly.yml`
- 文章：`source/_posts/`
- 单页（如关于）：`source/about/index.md`
