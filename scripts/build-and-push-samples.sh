set -eo
cd samples

currentWorkingDirectory=$(pwd)
declare -a directories
declare -a subDirectories

for file in *; do
    if [ -d "$file" ] && [ "$file" != "services" ]; then
        subDirectories+=("$file")
    fi
done

while [ ${#subDirectories[@]} -gt 0 ]
do
    declare -a tempDirectory
    for directory in ${subDirectories[*]}; do
        directoriesFound=0
        for children in $directory/*; do
            if [ -d "$children" ]; then
                if [[ ! "$children" == *docs ]]; then
                    directoryName=$(echo $children | sed -r  's/^(.+)\/([^\/]*)/\2/')
                    if [ "$directoryName" == "target" ]; then
                        rm -r $children
                    else
                        tempDirectory+=("$children")
                        directoriesFound=1
                    fi
                fi
            fi
        done

        if [ $directoriesFound -eq 0 ]; then
            directories+=("$directory")
        fi
    done
    unset subDirectories
    if [ "${#tempDirectory[*]}" -gt 0 ]; then
        subDirectories=${tempDirectory[*]}
    fi
    unset tempDirectory
done

for directory in ${directories[*]}; do
    echo "Building sample $directory"
    if test -f "$directory/sample.bal"; then
        if test -f "$directory/sample_temp.bal"; then
            mv "$directory/sample.bal" "$directory/sample.bal.tmp"
        fi
        packageName=$(echo "$directory" | sed -r  's/^(.+)\/([^\/]*)/\2/')

        cloudToml=$(cat << END
[container.image]
repository="$CONTAINER_REGISTRY"
name="$packageName"
tag="$SAMPLE_IMAGE_TAG" 
END
        )
        tomlFile=$(cat <<-END
[build-options]
cloud = "docker"
observabilityIncluded = true
END
        )
        obsBalFile=$(cat <<-END
import ballerinax/choreo as _;
END
        )	
        echo "$tomlFile" > $directory/Ballerina.toml
        echo "$cloudToml" > $directory/Cloud.toml
        echo "$obsBalFile" > $directory/observe.bal
        $BALLERINA_EXEC build $directory
        docker push $CONTAINER_REGISTRY/$packageName:$SAMPLE_IMAGE_TAG
        rm $directory/Ballerina.toml
        rm $directory/Cloud.toml
        rm -r $directory/target

        if test -f "$directory/sample_temp.bal"; then
            mv "$directory/sample.bal.tmp" "$directory/sample.bal"
        fi
    fi
done

cd ..