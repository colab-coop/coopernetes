#! /bin/sh

set -ex

if ! (output=$(git status --porcelain) && [ -z "$output" ]); then
  echo "Cowardly refusing to create git tag while repo is dirty"
  exit 1
fi

dir=$1
cd $dir
version=`cat VERSION`

image=${dir%/}
image_tag="colabcoop/$image:$version"
git_tag="image-$image-$version"

if git rev-parse $git_tag >/dev/null 2>&1; then
  echo "Cowardly refusing to build $image_tag when git tag $git_tag already exists"
  exit 1
fi

docker build -t $image_tag .
docker push $image_tag

git tag $git_tag
git push --tags

cd ..
