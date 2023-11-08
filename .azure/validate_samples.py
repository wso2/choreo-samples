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
    "many", "postman", "react", "docker"
]

def validate_metadata_and_thumbnails():
    """
    Validates the metadata and thumbnails of Choreo samples.

    This function iterates through the directories in the `.samples` directory and collects metadata from metadata files.
    It checks if the componentPath exists and if the thumbnail exists. It also checks if there are any directories without
    corresponding metadata files.

    Returns:
        True if all metadata and thumbnails are valid, otherwise raises a ValueError or FileNotFoundError.
    """

    # Iterate through directories and collect metadata from metadata files
    samples_dirnames_set = set()
    samples_dir = os.path.join(REPO_BASE_DIR, '.samples')
    for meta_file in os.listdir(samples_dir):
        meta_path = os.path.join(samples_dir, meta_file)
        
        if os.path.isfile(meta_path):
            with open(meta_path, 'r', encoding='utf-8') as f:
                data = yaml.safe_load(f)

                component_path = data.get('componentPath')
                # Check if the componentPath exists
                if not os.path.exists(os.path.join(REPO_BASE_DIR, component_path.lstrip('/'))):
                    if WSO2_SAMPLES_REPO_URL == data.get('repositoryUrl'):
                        raise ValueError(f"Error: Component path '{component_path}' does not exist. This will be excluded from index.json.")

                component_type = data.get('componentType', '')
                build_pack = data.get('buildPack', '')

                if component_type not in VALID_COMPONENT_TYPES:
                    raise ValueError(f"Warning: '{component_type}' is not a valid componentType for directory: {meta_file}. Excluding from index.json.")

                if build_pack not in VALID_BUILD_PACKS:
                    raise ValueError(f"Warning: '{build_pack}' is not a valid buildPreset for directory: {meta_file}. Excluding from index.json.")

            # Check if the thumbnail exists
            thumbnail_src = os.path.join(samples_dir, data.get('thumbnailPath').lstrip('/'))
            if not os.path.exists(thumbnail_src):
                raise FileNotFoundError(f"Thumbnail not found in {data.get('thumbnailPath')}")

            samples_dirnames_set.add(component_path.lstrip('/'))

    # Check if there are any directories without corresponding metadata files
    for dir_name in os.listdir(REPO_BASE_DIR):
        dir_path = os.path.join(REPO_BASE_DIR, dir_name)
        if os.path.isfile(dir_path) or dir_name.startswith('.'):
            continue
        if dir_name not in samples_dirnames_set:
            raise ValueError(f"Warning: Directory '{dir_name}' does not have a corresponding metadata file. This will be excluded form index.json.")

    return True


def main():
    try:
        is_valid = validate_metadata_and_thumbnails()
        if is_valid:
            print("Metadata validated successfully!")
        else:
            print("Metadata validation failed!")
    except (ValueError, FileNotFoundError) as e:
        print(f"Failed: {e}")

if __name__ == '__main__':
    main()
