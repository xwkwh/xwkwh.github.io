---
title: My Vim for Golang
date: 2018-06-09 16:12:35
categories: vim
tags: vim
---



## 配置

* 关键的俩个文件 

  * ~/.vim   "  插件位置
  * ~/.vimrc   "  配置文件

  安装的时候在.vim中复制相关插件文件，在vim中执行`:PluginInstall`即可进入安装，至Done！

## Vim插件

* Vundle 

  ```vim
  :VundleInstall 安装
  :VundleUpdate  更新
  :Vundleclean  清除不用的插件
  ```

+ YouCompleteMe      代码自动补全

  ~~~vim
  nnoremap <leader>gd :YcmCompleter GoTo<CR>
  ~~~

+ Vim-go      golang插件

+ NERDTree    文件目录树

  ```
  " 打开时默认开启
  autocmd VimEnter * NERDTree
  ```

+ NERDTreeCommentor    快速注释

+ ```
  <leader>cc 注释当前行
  <leader>cm 只用一组符号来注释
  <leader>cy 注释并复制
  <leader>cs 优美的注释
  <leader>cu 取消注释
  " 注释的时候自动加个空格, 强迫症必配
  let g:NERDSpaceDelims=1
  ```

+ Powerline    状态栏优雅显示

+ Tagbar     代码文档显示

+ ```
   " 按F9即可打开tagbar界面
   nmap <silent> <F9> :TagbarToggle<CR>
   " let g:tagbar_left=1
   let g:tagbar_right=1
   let g:tagbar_width=25
   let g:tagbar_type_go = {}
   ```
## 快捷键

### 查看快捷键帮助

* Vim默认的快捷键，可通过 `:help c-r`类似的命令查看
* 通过map定义的快捷键，可通过` :map ,jd` 类似的命令查看

### My 快捷键

|        快捷键        |       功能       |
| :------------------: | :--------------: |
| :q=fq  :wq=fwq :w=fw |     保存退出     |
|          ,w          |     Ctrl +w      |
|          be          | 显示缓存文件路径 |
|          F2          |     NERDTree     |
|          F9          | Tagbar（gotags） |
|    gm=:GoImports     |  goimports导包   |
|      gd   ctr+]      |     代码跳转     |
|    ctr+i / ctr+o     |   后退 、前进    |
|       ctr + t        |  代码跳转后退回  |
