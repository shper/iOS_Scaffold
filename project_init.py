#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import os
import sys
import os.path
import shutil

scaffold_name = "iOS_Scaffold"
scaffold_bundle_id = "cn.shper.scaffold"

project_name = ""
project_bundle_id = ""
git_user_name = ""
git_user_email = ""

current_path_new = ""

scaffold_file_list = [
    "iOS_Scaffold/Sources/AppDelegate.swift", 
    "iOS_ScaffoldTests/iOS_ScaffoldTests.swift", 
    "iOS_ScaffoldUITests/iOS_ScaffoldUITests.swift", 
    "iOS_Scaffold.xcodeproj/project.pbxproj",
    "iOS_Scaffold.xcworkspace/contents.xcworkspacedata",
    "Podfile"
]

scaffold_file_name_list = [
    "iOS_Scaffold",
    "iOS_Scaffold/Sources/iOS_Scaffold-Bridging-Header.h",
    "iOS_ScaffoldTests",
    "iOS_ScaffoldTests/iOS_ScaffoldTests.swift",
    "iOS_ScaffoldUITests",
    "iOS_ScaffoldUITests/iOS_ScaffoldUITests.swift",
    "iOS_Scaffold.xcodeproj",
    "iOS_Scaffold.xcworkspace"
]

# 替换文件中的关键字
def replace_str(file, old_str, new_str):
    if os.path.exists(file):
        file_data = ""
        with open(file, "r", encoding="utf-8") as f:
            for line in f:
                if old_str in line:
                    line = line.replace(old_str, new_str)
                file_data += line
        with open(file,"w", encoding="utf-8") as f:
            f.write(file_data)
        print("🚀 Done: " + file)

# 重命名文件名
def rename_file(old_file, new_file):
    if os.path.exists(old_file):
        os.rename(old_file, new_file)
        print("🚀 Done: " + new_file)

# 批量替换文件中的关键字
def batch_replace_content():
    for file in scaffold_file_list:
        replace_str(file, scaffold_name, project_name)
        # 处理 bundle id
        if file == "iOS_Scaffold.xcodeproj/project.pbxproj" and len(project_bundle_id) > 0:
            replace_str(file, scaffold_bundle_id, project_bundle_id)

# 批量替换文件名和目录名
def batch_rename_file():
    for file_name in scaffold_file_name_list:
        if file_name.find("/") > -1:
            file_name = file_name.replace(scaffold_name, project_name, 1)
        
        new_name = file_name.replace(scaffold_name, project_name)
        rename_file(file_name, new_name)

# 修改项目目录名称
def rename_project_path():
    global current_path_new

    current_path_old = os.getcwd()
    parent_path = os.path.join(current_path_old, os.pardir)
    current_path_new = os.path.abspath(parent_path) + "/" + project_name
    rename_file(current_path_old, current_path_new)

# 初始化 git
def git_init():
    print('🙋‍♂️ 初始化 git')
    shutil.rmtree(path=".git")
    os.system('git init')

    if len(git_user_name) > 1:
        os.system('git config user.name ' + git_user_name)
    if len(git_user_email) > 1:
        os.system('git config user.email ' + git_user_email)

    os.system('git add .')
    os.system("git commit -m 'Initial commit'")

# pod install
def pod_init():
    print('🙋‍♂️ 执行 pod install')
    os.system('pod install')

# 删除初始化脚本
def remove_self():
    os.remove('project_init.py')

def project_init():
    print("🙋‍♂️ 初始化项目：", project_name)
    # 批量替换文件中的关键字
    batch_replace_content()
    # 批量替换文件名和目录名
    batch_rename_file()
    # 修改项目目录名称
    rename_project_path()
    # 删除脚本
    remove_self()
    # 初始化 git
    git_init()
    # 初始化 pod
    pod_init()
    
    print('👉 工程路径：' + current_path_new)
    print('🎉 工程初始化完成!')

def main_fun():
    global project_name
    global project_bundle_id
    global git_user_name
    global git_user_email
    log_info = ""

    # 获取输入的基本信息
    if len(sys.argv) > 1:
        project_name = sys.argv[1]
        log_info += "Project name: " + project_name

    if len(sys.argv) > 2:
        project_bundle_id = sys.argv[2]
        log_info += " ;Bundle id: " + project_bundle_id
    
    if len(sys.argv) > 3:
        git_user_name = sys.argv[3]
        log_info += " ;git User Name: " + git_user_name
    
    if len(sys.argv) > 4:
        git_user_email = sys.argv[4]
        log_info += " ;git User Email: " + git_user_email
    
    if len(project_name) < 1:
        project_name = input("👉 请输入项目名称：")
        log_info += "Project name: " + project_name

    if len(project_bundle_id) < 1:
        project_bundle_id = input("👉 请输入 Bundle id：")
        log_info += " ;Bundle Id: " + project_bundle_id

    print("🚀 项目信息：", log_info)
    # 开始初始化
    project_init()

main_fun()