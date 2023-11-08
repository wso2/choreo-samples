import os
import yaml
import json
import shutil

REPO_BASE_DIR = os.environ['BUILD_SOURCESDIRECTORY']
BUILD_STAGING_DIRECTORY = os.environ['BUILD_STAGINGDIRECTORY']
BASE_URL_FOR_THUMBNAILS = 'https://choreo-shared-choreo-samples-cdne.azureedge.net'
WSO2_SAMPLES_REPO_URL = 'https://github.com/wso2/choreo-samples/'

VALID_COMPONENT_TYPES = [
    "service", "webhook", "manual-task", "scheduled-task", 
    "event-triggered", "event-handler", "test-runner", "many",
    "web-application"
]

VALID_BUILD_PACKS = [
    "ballerina", "wso2-mi", "go", "java", "php", "python", "nodejs", "ruby", 
    "many", "postman", "react", "docker"
]

def collect_metadata_and_thumbnails():
    collected_data = []
    print("Starting to collect metadata and thumbnails...")

    # Iterate through directories and collect metadata from metadata files
    samples_dirnames_set = set()
    samples_dir = os.path.join(REPO_BASE_DIR, '.samples')
    for meta_file in os.listdir(samples_dir):
        meta_path = os.path.join(samples_dir, meta_file)
        
        if os.path.isfile(meta_path):
            with open(meta_path, 'r') as f:
                data = yaml.safe_load(f)

                component_path = data.get('componentPath')
                # Check if the componentPath exists
                if not os.path.exists(os.path.join(REPO_BASE_DIR, component_path.lstrip('/'))):
                    if WSO2_SAMPLES_REPO_URL == data.get('repositoryUrl'):
                        print(f"Warning: Component path '{component_path}' does not exist. This will be excluded from index.json.")
                        continue

                component_type = data.get('componentType', '')
                build_pack = data.get('buildPack', '')

                if component_type not in VALID_COMPONENT_TYPES:
                    print(f"Warning: '{component_type}' is not a valid componentType for directory: {meta_file}. Excluding from index.json.")
                    continue

                if build_pack not in VALID_BUILD_PACKS:
                    print(f"Warning: '{build_pack}' is not a valid buildPreset for directory: {meta_file}. Excluding from index.json.")
                    continue

                # Check if tags key exists and if it's either not set or None, assign an empty list
                if not data.get('tags'):
                    data['tags'] = []

            # Copy thumbnail to staging directory.
            thumbnail_src = os.path.join(samples_dir, data.get('thumbnailPath').lstrip('/'))
            thumbnail_dest_folder = os.path.join(BUILD_STAGING_DIRECTORY, 'icons')
            os.makedirs(thumbnail_dest_folder, exist_ok=True)
            if os.path.exists(thumbnail_src):
                shutil.copy(thumbnail_src, thumbnail_dest_folder)
            else:
                print(f"Thumbnail not found for {thumbnail_src}")
            
            # Adjust the thumbnailPath
            data['thumbnailPath'] = BASE_URL_FOR_THUMBNAILS + data['thumbnailPath']

            samples_dirnames_set.add(component_path.lstrip('/'))
            collected_data.append(data)

    # Check if there are any directories without corresponding metadata files
    for dir_name in os.listdir(REPO_BASE_DIR):
        dir_path = os.path.join(REPO_BASE_DIR, dir_name)
        if os.path.isfile(dir_path) or dir_name.startswith('.'):
            continue
        if dir_name not in samples_dirnames_set:
            print(f"Warning: Directory '{dir_name}' does not have a corresponding metadata file. This will be excluded form index.json.")

    return collected_data

def generate_index_json(data):
    # Create index.json structure
    index_data = {
        "samples": data,
        "count": len(data)
    }

    with open(os.path.join(BUILD_STAGING_DIRECTORY, 'index-v7.json'), 'w') as f:
        json.dump(index_data, f, separators=(',', ':'))  # Remove whitespace to minimize file size
    print("Generated index.json")

def main():
    metadata_data = collect_metadata_and_thumbnails()
    if metadata_data:
        print(f"Collected data for {len(metadata_data)} samples.")
    else:
        print("No metadata collected!")
    generate_index_json(metadata_data)

if __name__ == '__main__':
    main()
