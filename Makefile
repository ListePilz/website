BUCKET=s3://liste-pilz-dns-listepilzwebbucket-1fum29mo6m881
DEV_BUCKET=s3://liste-pilz-dns-listepilzwebbucketdev-luoreq61zbqq

export AWS_DEFAULT_PROFILE = pilz

build: clean
	hugo

clean:
	rm -fr public

deploy: build
	cd public && aws s3 sync ./ $(BUCKET) --delete --acl public-read

dev-deploy: build
	aws s3 sync public/ $(DEV_BUCKET) --delete --acl public-read
	@echo http://$(DEV_BUCKET).s3-website.eu-central-1.amazonaws.com/

deploy-wip:
	aws s3 cp wip/index.html $(BUCKET)

deploy-secret: build
	aws s3 sync public $(BUCKET)/strenggeheim --delete

update: deploy deploy-wip deploy-secret

resize-images:
	imagemagick mogrify -resize 100 -path static/assets/images/portraits/small/ static/assets/images/portraits/original/*.jpg
	imagemagick mogrify -resize 150 -path static/assets/images/portraits/medium/ static/assets/images/portraits/original/*.jpg
	imagemagick mogrify -resize 500 -path static/assets/images/portraits/large/ static/assets/images/portraits/original/*.jpg
	imagemagick mogrify -resize 100 -path static/assets/images/groups/small/ static/assets/images/groups/original/*.jpg
	imagemagick mogrify -resize 150 -path static/assets/images/groups/medium/ static/assets/images/groups/original/*.jpg
	imagemagick mogrify -resize 500 -path static/assets/images/groups/large/ static/assets/images/groups/original/*.jpg