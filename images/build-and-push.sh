#! /bin/sh

set -ex

for dir in */; do
  cd $dir
  image=${dir%/}
  version=`cat VERSION`
  image_tag="colabcoop/$image:$version"
  git_tag="image-$image-$version"
  git tag $git_tag
  git push --tags
  docker build -t $image_tag .
  docker push $image_tag
  cd ..
done
