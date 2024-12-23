#!/usr/bin/env python3
# 说明:
# 1. 该脚本用于移除使用 dotnetPackages.fetch-deps 生成的依赖项文件中包含如下字段的内容
#     1. (fetchNuGet { .* pname = ".*-osx-.*"; })
#     2. (fetchNuGet {
#       pname = "osx|linux|"
#     })

import sys
import os
import re

def main(file_path):
    if not (os.path.exists(file_path) and os.path.isfile(file_path)):
        print("文件不存在或不是有效文件")
        return
    saveLines = []
    cacheLines = []
    save_cache = False
    with open(file_path, mode="r") as f:
        for i in f.readlines():
            if re.match(r'^\s+\(fetchNuGet.*\)\s*$', i):
                if not re.match(r'.*pname.*(linux|osx).*(arm64|x64)', i):
                    saveLines.append(i)
            elif re.match(r'\s+\(fetchNuGet\s+\{\s*', i):
                cacheLines.append(i)
                save_cache = True
            elif cacheLines:
                if re.match(r'.*pname.*(linux|osx)-(arm64|x64).*', i):
                    save_cache = False
                if re.match(r'\s+\}\)', i):
                    if save_cache:
                        saveLines.extend(cacheLines)
                        saveLines.append(i)
                    cacheLines = []
                    save_cache = False
                else:
                    cacheLines.append(i)
            else:
                saveLines.append(i)
    with open(file_path, mode="w") as f:
        f.writelines(saveLines)
    print(f"更新完成: {file_path}")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f"用法 python {os.path.basename(__file__)} <path>")
        exit(1)
    main(sys.argv[1])
