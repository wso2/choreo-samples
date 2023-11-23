# Choreo sample web app with vue

### Initilized with [Vue CLI](https://cli.vuejs.org/guide/creating-a-project.html#vue-create)

```shell
npx @vue/cli create vue-spa
```

### Use the following configuration when creating this component in Choreo:

- Build Pack: **Vue**
- Build Context Path: `web-apps/vue-spa`
- Build Command: `npm run build`
- Build output directory: `dist`
- Node Version: `18`

### Use thr following commands to build and run the app using Docker:

```shell
docker build -t vue-spa bring-your-own-image-components/web-apps/vue-spa
docker run -p 8080:80 vue-spa
```
