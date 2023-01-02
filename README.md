# david.gyttja.com

Static site source for https://david.gyttja.com.

## Dependencies:
* Hugo v0.109



## Localhost development

Continuous development:
```
hugo serve
```

Verify site for production build, site will be generated in `public/`
```
make clean compile
```

## Production deployment

Commits on main pushed to GitHub are built and deployed by Cloudflare Pages.
