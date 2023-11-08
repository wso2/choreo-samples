# Choreo sample web app with angular

### Initilized with [Angular CLI](https://angular.io/cli)

```shell
npx @angular/cli new angular-spa --defaults
```

### Use the following commands to create BYOI component

- Select Create Component with `Web Application` type.
- Provide component name and description.
- Select `Angular SPA` tile and create component.

### Use the following configuration when creating this component in Choreo:

- Build Pack: WebApp
- Build Context Path: `angular-single-page-app`
- Build Command: `npm run build`
- Build output directory: `dist/angular-single-page-app`
- Node Version: `18`

### Use thr following commands to build and run the app using Docker:

```shell
docker build -t angular-spa bring-your-own-image-components/web-apps/angular-spa
docker run -p 8080:80 angular-spa
```
