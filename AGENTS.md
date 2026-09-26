# 要求
除非用户当次明确同意（「可以下载」「去下载吧」等），否则不执行任何网络下载相关行为（如 `nix eval`/`nix build`/`nix flake update` 触发的输入拉取、`git fetch`/`git clone`/`git pull`、`curl`/`wget` 下载等）；网络搜索（web_search/web_fetch 等信息检索）不受此限制。此授权同样不延伸不累积，每次下载都需再次明确授权。

