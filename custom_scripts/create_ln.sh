#!/bin/bash

# 检查是否提供了前缀参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_prefix>"
    exit 1
fi

# 获取文件前缀
file_prefix="$1"

# 检查当前目录是否存在符合前缀的文件
matching_files=$(ls "$file_prefix"* 2>/dev/null)
if [ -z "$matching_files" ]; then
    echo "No files found with prefix: $file_prefix"
    exit 1
fi

# # 询问用户目标文件夹路径
# read -p "Enter the target directory path: " target_dir
target_dir="$MHOME/Projects/ComfyUI/models/loras"

# 检查目标文件夹是否存在，如果不存在则创建
if [ ! -d "$target_dir" ]; then
    echo "Target directory does not exist. Creating it..."
    mkdir -p "$target_dir"
fi

# 遍历当前目录中所有符合前缀的文件，并创建符号链接
for file in "$file_prefix"*; do
    if [ -f "$file" ]; then
        # 获取当前文件的绝对路径
        current_file_path=$(pwd)/"$file"
        # 目标文件夹中的符号链接路径
        link_path="$target_dir"/"$file"
        # 创建符号链接
        ln -s "$current_file_path" "$link_path"
        echo "Created symlink: $link_path -> $current_file_path"
    fi
done

echo "Done!"
