#! /bin/sh

set -ex

dir=$1
cd $dir
version=`cat VERSION`

image=${dir%/}
image_tag="colabcoop/$image:$version"
docker build -t $image_tag .
docker push $image_tag

git_tag="image-$image-$version"
git tag $git_tag
git push --tags

cd ..
