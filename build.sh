#!/bin/sh

build_interval=${BUILD_INTERVAL:-$((3600*24))}
target_repo=git@github.com:ktateish/etcd.git
upstream_repo=https://github.com/coreos/etcd.git

D=$GOPATH/src/github.com/coreos/
mkdir -p $D
cd $D

git clone $target_repo
cd $D/etcd
git remote add upstream $upstream_repo

while :
do
	git remote update -p
	for b in master release-3.0
	do
		# Update normal branch first
		git push origin remotes/upstream/$b:$b

		# build binaries
		git checkout --force upstream/$b
		echo "build binaries for $b started on $(date)"
		./build
		echo "done. build status: $?"

		# create commit with newly built binaries
		git checkout -B alpine/$b alpine/${b}-init
		mv -f bin/etcd bin/etcdctl .
		git add etcd etcdctl
		git commit -m "Update for $(git describe upstream/$b)"

		# this push will kick docker build on hub.docker.com
		#   I decided to force push because etcd+etcdctl binaries
		#   consume about 40MB and will be 1.2GB/month by daily build.
		git push origin +alpine/$b
		git clean -fdx
	done
	echo "sleep $build_interval on $(date)"
	sleep $build_interval
done
