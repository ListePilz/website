build: clean
	hugo

clean:
	rm -fr public

deploy: build
	cd public && aws s3 sync . s3://liste-pilz-dns-listepilzwebbucket-1fum29mo6m881 --profile pilz