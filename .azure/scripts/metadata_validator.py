import os
import yaml
import json
import shutil

REPO_BASE_DIR = os.environ['BUILD_SOURCESDIRECTORY']
WSO2_SAMPLES_REPO_URL = 'https://github.com/wso2/choreo-samples/'

VALID_COMPONENT_TYPES = [
    "service", "webhook", "manual-task", "scheduled-task", 
    "event-triggered", "event-handler", "test-runner", "many",
    "web-application"
]

VALID_BUILD_PACKS = [
    "ballerina", "wso2-mi", "go", "java", "php", "python", "nodejs", "ruby",
    "vue", "many", "postman", "react", "docker", "angular"
]

def validate_component_path(component_path, repository_url):
    if not os.path.exists(os.path.join(REPO_BASE_DIR, component_path.lstrip('/'))):
        if WSO2_SAMPLES_REPO_URL == repository_url:
            return False
    return True

def validate_component_type(component_type):
    if component_type not in VALID_COMPONENT_TYPES:
        return False
    return True

def validate_build_pack(build_pack):
    if build_pack not in VALID_BUILD_PACKS:
        return False
    return True

def validate_directories_for_metafiles(samples_dirnames_set):
    # Check if there are any directories without corresponding metadata files
    for dir_name in os.listdir(REPO_BASE_DIR):
        dir_path = os.path.join(REPO_BASE_DIR, dir_name)
        if os.path.isfile(dir_path) or dir_name.startswith('.'):
            continue
        if dir_name not in samples_dirnames_set:
            return False, dir_name
    return True, None

def validate_thumbnail(thumbnail_src):
    if not os.path.exists(thumbnail_src):
        return False
    return True


