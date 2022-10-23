
compile:
	HUGO_ENVIRONMENT=production HUGO_ENV=production hugo --minify

clean:
	rm -rf public/*
