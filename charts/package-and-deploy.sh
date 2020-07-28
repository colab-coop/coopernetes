#! /bin/sh

set -ex

if ! (output=$(git status --porcelain) && [ -z "$output" ]); then
  echo "Cowardly refusing to create git tag while repo is dirty"
  exit 1
fi

dir=$1
repo=$(git rev-parse --show-toplevel)/docs/charts/

helm package $dir
chart=$(find . -name "$dir-*.tgz" | sed "s|^\./||")
mv $chart $repo
helm repo index $repo --url https://colab-coop.github.io/coopernetes/charts/

git_tag=${chart%.tgz}
git add -A $repo
git commit -m "Release $git_tag"
git tag $git_tag
git push --tags
