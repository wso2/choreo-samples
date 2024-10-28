import os
import yaml
import json
import shutil
import metadata_validator
import subprocess

REPO_BASE_DIR = os.environ['BUILD_SOURCESDIRECTORY']
SAMPLE_COMPONENT_TYPE_SERVICE = 'service'
CHOREO_ACR_BASE_URL = 'choreoanonymouspullable.azurecr.io'

def validate_metadata_and_thumbnails():
    """
    Validates the metadata and thumbnails of Choreo samples.

    This function iterates through the directories in the `.samples` directory and collects metadata from metadata files.
    It checks if the componentPath exists and if the thumbnail exists. It also checks if there are any directories without
    corresponding metadata files.
    """

    # Iterate through directories and collect metadata from metadata files
    samples_dirnames_set = set()
    samples_dir = os.path.join(REPO_BASE_DIR, '.samples')
    for meta_file in os.listdir(samples_dir):
        meta_path = os.path.join(samples_dir, meta_file)
        
        if os.path.isfile(meta_path):
            with open(meta_path, 'r') as f:
                data = yaml.safe_load(f)

                display_name = data.get('displayName')
                if not display_name:
                    raise ValueError(f"Error: 'displayName' is not set for the sample: {meta_file}.")
                
                description = data.get('description')
                if not description:
                    raise ValueError(f"Error: 'description' is not set for the sample: {meta_file}.")

                documentation_path = data.get('documentationPath')
                if not documentation_path:
                    raise ValueError(f"Error: 'documentationPath' is not set for the sample: {meta_file}.")
                
                component_path = data.get('componentPath')
                if not component_path:
                    raise ValueError(f"Error: 'componentPath' is not set for the sample: {meta_file}.")
                
                repository_url = data.get('repositoryUrl')
                if not repository_url:
                    raise ValueError(f"Error: 'repositoryUrl' is not set for the sample: {meta_file}.")
                
                component_type = data.get('componentType', '')
                if not metadata_validator.validate_component_type(component_type):
                    raise ValueError(f"Error: '{component_type}' is not a valid component type for the sample: {meta_file}.")
                
                tags = data.get('tags')
                if tags and not isinstance(tags, list):
                    raise ValueError(f"Error: 'tags' is not a list for the sample: {meta_file}.")
                
                
                image_version = data.get('imageVersion')
                if image_version:
                    
                    if not metadata_validator.is_component_type_quick_deployable(component_type):
                        raise ValueError(f"Error: '{component_type}' is not a quick deployable component type for the sample: {meta_file}.")
                    
                    #Check if a Dockerfile exists in the sample directory
                    dockerfile_path = os.path.join(REPO_BASE_DIR, component_path.lstrip('/'), 'Dockerfile')
                    if not os.path.exists(dockerfile_path):
                        raise FileNotFoundError(f"Error: Dockerfile not found in {component_path.lstrip('/')}")
                    
                    #Check if build succeed with the Dockerfile
                    image_name = display_name.strip().lower().replace(' ', '-')
                    image_url = f"{CHOREO_ACR_BASE_URL}/samples/{image_name}:{image_version}"
                    data['imageUrl'] = image_url

                    # Attempt to pull the image from ACR
                    pull_command = ['docker', 'pull', image_url]
                    pull_result = subprocess.run(pull_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    
                    if not pull_result.returncode == 0:
                        # Build the Docker image
                        component_full_path = os.path.join(REPO_BASE_DIR, component_path.lstrip('/'))
                        build_command = ['docker', 'build', '-t', image_url, component_full_path]
                        build_result = subprocess.run(build_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                        if build_result.returncode != 0:
                            raise RuntimeError(f"Error building image {image_url}: {build_result.stderr.decode('utf-8')}")
                    
                    # Check if openapi.yaml and endpoints.yaml exist if the component type is a service
                    if component_type == SAMPLE_COMPONENT_TYPE_SERVICE:
                        endpoints_path = os.path.join(REPO_BASE_DIR, component_path.lstrip('/'), '.choreo/endpoints.yaml')
                        if not os.path.exists(endpoints_path):
                            raise FileNotFoundError(f"Error: endpoints.yaml not found in {component_path.lstrip('/')}")
                        # openapi.yaml is required if service type is REST
                        #Read endpoints.yaml to check if the service type is REST
                        with open(endpoints_path, 'r') as f:
                            endpoints_data = yaml.safe_load(f)
                            if endpoints_data.get('type') == 'REST':
                                schema_path = endpoints_data.get('schemaFilePath')
                                openapi_path = os.path.join(REPO_BASE_DIR, component_path.lstrip('/'), schema_path.lstrip('/'))
                                if not os.path.exists(openapi_path):
                                    raise FileNotFoundError(f"Error: openapi.yaml not found in {component_path.lstrip('/')}")                        
            
                # Check if the componentPath exists
                if not metadata_validator.validate_component_path(component_path, repository_url):
                    raise ValueError(f"Error: Component path '{component_path}' does not exist. This will be excluded from index.json.")

                component_type = data.get('componentType', '')
                if not metadata_validator.validate_component_type(component_type):
                    raise ValueError(f"Error: '{component_type}' is not a valid component type for the sample: {meta_file}.")
                
                build_pack = data.get('buildPack', '')
                if not metadata_validator.validate_build_pack(build_pack):
                    raise ValueError(f"Error: '{build_pack}' is not a valid build pack for the sample: {meta_file}.")

            thumbnail_src = os.path.join(samples_dir, data.get('thumbnailPath').lstrip('/'))
            if not metadata_validator.validate_thumbnail(thumbnail_src):
                raise FileNotFoundError(f"Thumbnail not found in {data.get('thumbnailPath')}")

            samples_dirnames_set.add(component_path.lstrip('/'))

    # Check if there are any directories without corresponding metadata files
    is_valid, dir_name = metadata_validator.validate_directories_for_metafiles(samples_dirnames_set)
    if not is_valid:
        raise ValueError(f"Error: Directory '{dir_name}' does not have a corresponding metadata file.")

def main():
    try:
        validate_metadata_and_thumbnails()
    except (ValueError, FileNotFoundError) as e:
        print(f"Failed: {e}")
        exit(1)

if __name__ == '__main__':
    main()
