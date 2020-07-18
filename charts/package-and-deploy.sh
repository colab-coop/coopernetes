#! /bin/sh

helm package */
mv *.tgz $(git rev-parse --show-toplevel)/docs/charts/
