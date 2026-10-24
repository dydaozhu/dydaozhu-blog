# blog.mcfwq.top

个人博客。Hexo 生成静态页面，Butterfly 主题，Cloudflare Pages 托管，Pages CMS 提供网页写作后台。

**没有服务器、没有数据库。** 你写的每篇文章都是仓库里的一个 `.md` 文件，推送到 GitHub 后 Cloudflare 自动构建上线。

---

## 目录结构

```
blog/
├── build.sh                Cloudflare 构建脚本：拉主题 → 装依赖 → 生成
├── .pages.yml              写作后台的字段定义（改这里 = 改后台表单）
├── .gitignore
├── package.json            依赖清单
├── _config.yml             站点配置：标题、作者、url
├── _config.butterfly.yml   主题配置：导航、头像、深色模式、搜索
├── scaffolds/              hexo new 生成文章的模板
├── themes/                 主题目录（构建时自动拉取，不进仓库）
└── source/
    ├── _posts/             所有文章
    ├── about/index.md      关于页
    ├── tags/index.md       标签页
    ├── categories/index.md 分类页
    ├── admin/index.html    /admin 跳转到写作后台
    ├── css/custom.css      自定义样式
    ├── img/                头像、横幅、favicon
    └── images/             文章配图（后台上传的图也进这里）
```

---

## 上线两步

> **主题不用你上传。** Butterfly 有 400 多个文件，而 GitHub 网页上传一次最多 100 个，
> 所以主题由 `build.sh` 在 Cloudflare 构建时自动拉取。仓库里只需要这二十来个文件。

### 第 1 步：创建 GitHub 仓库并上传

1. 打开 https://github.com/new
2. 仓库名填 `blog`，**选择 Public**（私有仓库要多授权一次，没必要）
3. 不要勾选 "Add a README file"
4. 创建后，把本目录的文件传上去（`themes/` 不用传）

有 git 的话最省事：

```bash
cd blog
git init
git add .
git commit -m "init: hexo + butterfly"
git branch -M main
git remote add origin https://github.com/你的用户名/blog.git
git push -u origin main
```

没有 git 就用网页的 **Add file → Upload files**，一次拖二十来个文件完全在限制内（注意保持子目录结构）。

### 第 2 步：创建 Cloudflare Pages 项目

Cloudflare Dashboard → **Workers & Pages → Create → Pages → Connect to Git** → 选择 `blog` 仓库。

构建设置**以这张表为准**（预设填了什么都要改回来）：

| 字段 | 值 |
| --- | --- |
| Production branch | `main` |
| Framework preset | `Hexo`（列表里没有就选 `None`） |
| Build command | `bash build.sh` |
| Build output directory | `public` |
| Root directory | 留空 |

再补一个环境变量：

| 变量名 | 值 |
| --- | --- |
| `NODE_VERSION` | `20` |

点 **Save and Deploy**。构建日志里应该依次看到：

```
==> 检查主题
    拉取 Butterfly 5.7.0 → themes/butterfly
==> 安装依赖
==> 生成静态文件
==> 构建完成
    public/ 下共 xxx 个文件
```

成功后会先给你一个 `xxx.pages.dev` 地址，打开确认样式正常。

---

## 绑定 blog.mcfwq.top

在 Pages 项目里 → **Custom domains → Set up a custom domain** → 输入 `blog.mcfwq.top` → 确认。

因为你的域名 DNS 已经在 Cloudflare，这一步**会自动写入 CNAME 记录，证书也会自动签发**。

⚠️ 两个不要：

- **不要**自己去 DNS 面板手动加这条记录，会和 Pages 托管的那条打架；
- **不要**动 `mcfwq.top` 现有的 301 和 `dsmp.mcfwq.top`，两个站互不影响。

第一次访问可能要等 1~2 分钟证书生效。

---

## 日常写文章

### 方式一：网页后台（推荐）

1. 打开 https://blog.mcfwq.top/admin
2. 会跳到 Pages CMS，用 GitHub 登录
3. 首次使用会要求安装 GitHub App —— 只授权 `blog` 这一个仓库
4. 左侧选「文章」→ 新建 → 填标题、时间、分类、标签 → 写正文（支持 Markdown，也支持可视化切换）
5. 保存后自动提交到仓库，约 1 分钟线上生效

正文编辑器右上角可以切换 **Editor / Source**，写 Markdown 用 Source 模式最直观。

> 后台第一次打开如果只有"文件"没有"文章"，说明 `.pages.yml` 还没推上去，或推的分支不是 `main`。

### 方式二：GitHub 网页直接改

仓库 → `source/_posts/` → Add file → Create new file，文件名 `my-post.md`，开头必须有：

```yaml
---
title: 文章标题
date: 2026-10-24 20:00:00
categories:
  - 随笔
tags:
  - 标签
---
```

下面是正文。写完 Commit 即可。

### 方式三：本地写（需要 Node + Git）

```bash
bash build.sh      # 首次会拉主题并装依赖
npm run server     # http://localhost:4000 实时预览
```

---

## 个人信息（已填好）

| 位置 | 内容 |
| --- | --- |
| `_config.yml` 顶部 | 标题 `dydaozhu's blog`、作者 `dydaozhu`、描述 |
| `_config.butterfly.yml` → `social:` | GitHub、Modrinth、RSS 三个链接 |
| `_config.butterfly.yml` → `aside.card_author` | 侧边栏作者卡片文案 + GitHub 按钮 |
| `source/about/index.md` | 关于页：GitHub / Modrinth / Discord / QQ / Minecraft 五个账号 |
| `source/img/avatar.jpg` | 头像（448×448） |
| `source/img/favicon.png` | 浏览器标签图标，从头像裁的 |

想再改博客名字就动 `_config.yml` 的 `title`；想加邮箱链接，在 `social:` 里加一行：

```yaml
social:
  fas fa-envelope: mailto:你的邮箱 || Email || '#4a7dbe'
```

改完 `_config.yml` 或 `_config.butterfly.yml` 后，需要重新部署才生效（Pages 会在推送后自动重新构建）。

---

## 常见问题

**构建日志里没有 "拉取 Butterfly" 这一行**
说明 `themes/butterfly` 已经存在于仓库里，`build.sh` 会跳过拉取。把仓库里的 `themes/` 整个删掉再重新部署。

**页面能打开但完全没有样式**
主题没拉下来。翻构建日志找 `git clone` 那一步是否报错。

**构建失败：`Cannot find module 'hexo-renderer-pug'`**
Butterfly 是 Pug + Stylus 写的，必须有这两个渲染器。确认 `package.json` 里存在 `hexo-renderer-pug` 和 `hexo-renderer-stylus`。

**搜索点了没反应**
需要 `hexo-generator-searchdb`（已包含）且 `_config.butterfly.yml` 里 `search.use: local_search`。确认后重新构建。

**代码块出现两个框 / 重复高亮**
`_config.yml` 里 `highlight.enable` 和 `prismjs.enable` 必须都是 `false`，高亮由主题负责。

**改了配置但线上没变**
看 Pages 的 **Deployments** 列表，最新一条是不是 `Success`。是的话按 `Ctrl + F5` 强刷。

**单文件超限**
Pages 单个文件上限 25 MiB。图片先压缩再上传。

---

## 想改主题源码怎么办

`build.sh` 是给"主题不进仓库"准备的。只有当你真要改 Butterfly 的 pug/stylus 源文件时才需要换方案：

1. 本地克隆主题到 `themes/butterfly`，删掉里面的 `.git`
2. 把 `.gitignore` 里的 `themes/` 一行删掉
3. 用 Git 客户端提交（几百个文件，别用网页上传）
4. `build.sh` 检测到 `themes/butterfly/_config.yml` 已存在，会自动跳过拉取

绝大多数情况用不着——配色、导航、卡片开关全在 `_config.butterfly.yml` 里。

---

## 之后可以加的东西

- **评论**：`_config.butterfly.yml` 里把 `comments.use` 改成 `Giscus` 或 `Twikoo`。注意国内读者大多没有 GitHub 账号，Giscus 会挡住一部分人。
- **统计**：Cloudflare Web Analytics 免费且无需 Cookie，拿到 token 填进 `_config.butterfly.yml` 的 `cloudflare_analytics`。
- **ICP 备案**：想让国内访问更快就得备案 + 国内 CDN，Cloudflare 免费版在国内的速度是它的短板。
- **GitHub Pages 镜像**：同一仓库可以再开一个 GitHub Pages 做备站，但两边配置会各自漂移，非必要不建议。
