
# INSTALACION:

## watchexec

https://github.com/watchexec/watchexec/releases

Copiar en `/usr/bin`

## sass

http://sass-lang.com/install

```
npm install -g sass
```

## mustache

https://www.npmjs.com/package/mustache

```
npm install -g mustache
```

## html-minifier

https://www.npmjs.com/package/html-minifier
https://stackoverflow.com/a/45396985

```
npm install -g html-minifier
```

## uglifyjs

https://www.npmjs.com/package/uglify-js
https://stackoverflow.com/a/20653631

```
npm install -g uglify-js
```

## uglifycss

https://www.npmjs.com/package/uglifycss

```
npm install -g uglifycss
```

## browser-sync

https://browsersync.io/

```
npm install -g browser-sync
```

# ERRORES:

`awk: not an option: -i`

```
apt install gawk -y
update-alternatives --config awk
```

Seleccionar `gawk`

https://askubuntu.com/questions/561621/choosing-awk-version-on-ubuntu-14-04

# EXECUCION:

## Terminal 1, donde se regenerarán los html

```
./sherpa.sh package
nohup watchexec -w src ./sherpa.sh html_watch &
```

## Terminal 2, donde se actualizará el navegador al haber cambios

```
cd target
browser-sync start --server --files "*.*" &
```

## Terminal 3, donde se regenerará el SASS

```
nohup ./sherpa.sh sass_watch &
```

