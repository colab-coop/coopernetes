#! /bin/sh

repo=$(git rev-parse --show-toplevel)/docs/charts/
helm package */
mv *.tgz $repo
helm repo index $repo --url https://colab-coop.github.io/coopernetes/charts/
