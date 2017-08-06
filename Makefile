BUCKET=s3://liste-pilz-dns-listepilzwebbucket-1fum29mo6m881
DEV_BUCKET=s3://liste-pilz-dns-listepilzwebbucketdev-luoreq61zbqq

export AWS_DEFAULT_PROFILE = pilz

build: clean
	hugo

clean:
	rm -fr public

deploy: build
	cd public && aws s3 sync ./ $(BUCKET) --delete

dev-deploy: build
	aws s3 sync public/ $(DEV_BUCKET) --delete --acl public-read

deploy-wip:
	aws s3 cp wip/index.html $(BUCKET)

deploy-secret: build
	aws s3 sync public $(BUCKET)/strenggeheim --delete

update: deploy deploy-wip deploy-secret

resize-images:
	imagemagick mogrify -resize 100 -path static/assets/images/portraits/small/ static/assets/images/portraits/original/*.jpg
	imagemagick mogrify -resize 150 -path static/assets/images/portraits/medium/ static/assets/images/portraits/original/*.jpg
	imagemagick mogrify -resize 300 -path static/assets/images/portraits/large/ static/assets/images/portraits/original/*.jpg