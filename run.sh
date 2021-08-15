# Version 4.11.2 of yq (https://github.com/mikefarah/yq)
# Tidy up
mkdir -p .outputs
rm -rf .outputs/*

# Config for Kustomize to discover plugins in right place
export XDG_CONFIG_HOME=/home/rob/Documents/repos/kustomize-test

# Split YAML documents into individual JSON files
# Script adapted from https://stackoverflow.com/a/67876873
# --enable_alpha_plugins required to allow custom plugin
x="$(kustomize build --enable_alpha_plugins overlays/production)"
while [[ -n "$x" ]]
do ary+=("${x%%---*}")
if [[ "$x" =~ --- ]]; then x="${x#*---}"; else x=''; fi
done
for yml in "${ary[@]}";
    do fileName=`echo "$yml" | yq eval '.metadata.name' -`;
    echo $(echo "$yml" | yq eval -j) > .outputs/$fileName.json;
done

# Remove intermediate file
rm -rf kustomize_output.yml
