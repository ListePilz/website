BUCKET=s3://liste-pilz-dns-listepilzwebbucket-1fum29mo6m881

export AWS_DEFAULT_PROFILE = pilz

build: clean
	hugo

clean:
	rm -fr public

deploy: build
	cd public && aws s3 sync . $(BUCKET) --delete

deploy-wip:
	aws s3 cp wip/index.html $(BUCKET)

deploy-secret: build
	aws s3 sync public $(BUCKET)/strenggeheim --delete